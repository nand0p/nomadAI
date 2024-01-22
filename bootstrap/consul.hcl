server           = true
datacenter       = "dc-aws-001"
data_dir         = "/opt/consul"
bootstrap_expect = 3
client_addr      = "0.0.0.0"
bind_addr        = "BIND_ADDRESS"
encrypt          = "CONSUL_ENCRYPTION_KEY"
#license_path    = "/etc/consul.d/consul.hclic"

ui_config = {
  enabled = true
}

retry_join = [
  "NOMADIC_ONE_IP",
  "NOMADIC_TWO_IP",
  "NOMADIC_THREE_IP"
]
 
