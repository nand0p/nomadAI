data "aws_ami" "nomad_ai" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "template_file" "nomad_ai_boot" {
  template = file("${abspath(path.root)}/bootstrap/nomad_ai.sh")
  vars = {
    BRANCH           = var.nomad_ai_branch
    CONSUL_VERSION   = var.consul_version
    NOMAD_VERSION    = var.nomad_version
    REGION           = var.aws_region
  }
}

resource "aws_instance" "nomad_ai_one" {
  depends_on                  = [ aws_key_pair.nomad_ai_key, local_file.ssh_key, aws_ssm_parameter.nomad_ai_key ]
  ami                         = var.nomad_ai_ami_id == "" ? data.aws_ami.nomad_ai.id : var.nomad_ai_ami_id
  instance_type               = var.nomad_ai_instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [local.secgroup_id]
  iam_instance_profile        = aws_iam_instance_profile.nomad_ai[0].name
  user_data                   = data.template_file.nomad_ai_boot.rendered
  associate_public_ip_address = var.allow_public_ip
  tags                        = local.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = local.tags
  }
}

resource "aws_instance" "nomad_ai_two" {
  depends_on                  = [ aws_key_pair.nomad_ai_key, local_file.ssh_key, aws_ssm_parameter.nomad_ai_key ]
  ami                         = var.nomad_ai_ami_id == "" ? data.aws_ami.nomad_ai.id : var.nomad_ai_ami_id
  instance_type               = var.nomad_ai_instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [local.secgroup_id]
  iam_instance_profile        = aws_iam_instance_profile.nomad_ai[0].name
  user_data                   = data.template_file.nomad_ai_boot.rendered
  associate_public_ip_address = var.allow_public_ip
  tags                        = local.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = local.tags
  }
}

resource "aws_instance" "nomad_ai_three" {
  depends_on                  = [ aws_key_pair.nomad_ai_key, local_file.ssh_key, aws_ssm_parameter.nomad_ai_key ]
  ami                         = var.nomad_ai_ami_id == "" ? data.aws_ami.nomad_ai.id : var.nomad_ai_ami_id
  instance_type               = var.nomad_ai_instance_size
  key_name                    = var.key_name
  subnet_id                   = local.subnet_id
  vpc_security_group_ids      = [local.secgroup_id]
  iam_instance_profile        = aws_iam_instance_profile.nomad_ai[0].name
  user_data                   = data.template_file.nomad_ai_boot.rendered
  associate_public_ip_address = var.allow_public_ip
  tags                        = local.tags

  root_block_device {
    volume_size = var.root_volume_size
    volume_type = var.root_volume_type
    tags        = local.tags
  }
}

resource "aws_ssm_parameter" "nomad_ai_1" {
  name      = "nomad_ai_1"
  type      = "String"
  value     = "nomad1 ${aws_instance.nomad_ai_one.private_ip}"
}
resource "aws_ssm_parameter" "nomad_ai_2" {
  name      = "nomad_ai_2"
  type      = "String"
  value     = "nomad2 ${aws_instance.nomad_ai_two.private_ip}"
}
resource "aws_ssm_parameter" "nomad_ai_3" {
  name      = "nomad_ai_3"
  type      = "String"
  value     = "nomad3 ${aws_instance.nomad_ai_three.private_ip}"
}

resource "aws_ssm_parameter" "nomad_ai_instance_ips" {
  name      = "nomad_ai_instance_ips"
  type      = "String"
  value     = "${aws_instance.nomad_ai_one.public_ip},${aws_instance.nomad_ai_two.public_ip},${aws_instance.nomad_ai_three.public_ip}"
}
