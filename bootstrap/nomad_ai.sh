#!/bin/bash -ex


echo get cluster node ip address
LOCAL_IP=$(hostname -I | cut -d' ' -f1)
echo LOCAL_IP: $${LOCAL_IP}


echo install dependencies
yum -y update
yum -y install git nmap nc htop yum-utils wget


# NOTE: use consul/nomad passed pinned versions
yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo


echo install service packages
yum -y install docker consul nomad
usermod -aG docker ec2-user
systemctl enable docker
systemctl start docker


echo configure cluster nodes
aws ssm get-parameter \
  --with-decryption \
  --region ${REGION} \
  --name nomad_ai_key \
  --output text \
  --query Parameter.Value | tee /home/ec2-user/.ssh/id_rsa

aws ssm get-parameter \
  --with-decryption \
  --region ${REGION} \
  --name nomad_ai_1 \
  --output text \
  --query Parameter.Value | tee /home/ec2-user/nomad1
aws ssm get-parameter \
  --with-decryption \
  --region ${REGION} \
  --name nomad_ai_2 \
  --output text \
  --query Parameter.Value | tee /home/ec2-user/nomad2
aws ssm get-parameter \
  --with-decryption \
  --region ${REGION} \
  --name nomad_ai_3 \
  --output text \
  --query Parameter.Value | tee /home/ec2-user/nomad3

IP1=$(cut -d' ' -f2 /home/ec2-user/nomad1)
IP2=$(cut -d' ' -f2 /home/ec2-user/nomad2)
IP3=$(cut -d' ' -f2 /home/ec2-user/nomad3)
echo ip1 $${IP1}
echo ip2 $${IP2}
echo ip3 $${IP3}

chown -c ec2-user. /home/ec2-user/.ssh/id_rsa
chmod -c 0400 /home/ec2-user/.ssh/id_rsa
cat /home/ec2-user/nomad1 | tee -a /etc/hosts
cat /home/ec2-user/nomad2 | tee -a /etc/hosts
cat /home/ec2-user/nomad3 | tee -a /etc/hosts
cat /etc/hosts
if grep $${LOCAL_IP} /home/ec2-user/nomad1; then
   hostnamectl set-hostname nomad1
elif grep $${LOCAL_IP} /home/ec2-user/nomad2; then
   hostnamectl set-hostname nomad2
elif grep $${LOCAL_IP} /home/ec2-user/nomad3; then
   hostnamectl set-hostname nomad3
fi
hostname

echo configure consul
wget -O /etc/consul.d/consul.hcl https://raw.githubusercontent.com/nand0p/nomadai/${BRANCH}/bootstrap/consul.hcl
CONSUL_KEY=$(aws ssm get-parameter --with-decryption --region ${REGION} --name consul_encryption_key --output text --query Parameter.Value)
sed -i "s|CONSUL_ENCRYPTION_KEY|$${CONSUL_KEY}|g" /etc/consul.d/consul.hcl
sed -i "s|NOMADIC_ONE_IP|$${IP1}|g" /etc/consul.d/consul.hcl
sed -i "s|NOMADIC_TWO_IP|$${IP2}|g" /etc/consul.d/consul.hcl
sed -i "s|NOMADIC_THREE_IP|$${IP3}|g" /etc/consul.d/consul.hcl
sed -i "s|BIND_ADDRESS|$${LOCAL_IP}|g" /etc/consul.d/consul.hcl
if [ "$${IP1}" == "$${LOCAL_IP}" ]; then
  echo "advertise_addr = \"$${IP1}\"" | tee -a /etc/consul.d/consul.hcl
  echo "client_addr = \"127.0.0.1 $${IP1}\"" | tee -a /etc/consul.d/consul.hcl
elif [ "$${IP2}" == "$${LOCAL_IP}" ]; then
  echo "advertise_addr = \"$${IP2}\"" | tee -a /etc/consul.d/consul.hcl
  echo "client_addr = \"127.0.0.1 $${IP2}\"" | tee -a /etc/consul.d/consul.hcl
elif [ "$${IP3}" == "$${LOCAL_IP}" ]; then
  echo "advertise_addr = \"$${IP3}\"" | tee -a /etc/consul.d/consul.hcl
  echo "client_addr = \"127.0.0.1 $${IP3}\"" | tee -a /etc/consul.d/consul.hcl
fi
cat /etc/consul.d/consul.hcl
systemctl enable consul
systemctl start consul


echo configure nomad
mv -v /etc/nomad.d/nomad.hcl /etc/nomad.d/nomad.hcl.orig
wget -O /etc/nomad.d/nomad.hcl https://raw.githubusercontent.com/nand0p/nomadai/${BRANCH}/bootstrap/nomad.hcl
sed -i "s|NOMADIC_ONE_IP|$${IP1}|g" /etc/nomad.d/nomad.hcl
sed -i "s|NOMADIC_TWO_IP|$${IP2}|g" /etc/nomad.d/nomad.hcl
sed -i "s|NOMADIC_THREE_IP|$${IP3}|g" /etc/nomad.d/nomad.hcl
cat /etc/nomad.d/nomad.hcl
systemctl enable nomad
systemctl start nomad


echo pause and verify_cluster
which consul
which nomad
sleep 60
/usr/bin/consul version
/usr/bin/consul info
/usr/bin/consul members
systemctl status consul
journalctl -u consul

/usr/bin/nomad version
/usr/bin/nomad status
/usr/bin/nomad agent-info
systemctl status nomad
journalctl -u nomad

echo clone nomadic repo
git clone https://github.com/nand0p/nomadai.git /home/ec2-user/nomadai
chown -R ec2-user. /home/ec2-user/nomadai
