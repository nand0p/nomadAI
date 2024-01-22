datacenter = "dc-aws-001"

data_dir = "/opt/consul"

ui_config = {
  enabled = true
}

server = true

bind_addr = "BIND_ADDRESS"

bootstrap_expect=3

encrypt = "CONSUL_ENCRYPTION_KEY"

retry_join = [
  "NOMADIC_ONE_IP",
  "NOMADIC_TWO_IP",
  "NOMADIC_THREE_IP"
]
 
#license_path = "/etc/consul.d/consul.hclic"
