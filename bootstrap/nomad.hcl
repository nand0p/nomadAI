data_dir   = "/opt/nomad/data"
bind_addr  = "0.0.0.0"
datacenter = "dc-aws-001"


server {
  enabled          = true
  bootstrap_expect = 3
  #license_path    = "/etc/nomad.d/nomad.hcl"

  server_join {
    retry_join = [
      "NOMADIC_ONE_IP:4648",
      "NOMADIC_TWO_IP:4648",
      "NOMADIC_THREE_IP:4648"
    ]
  }
}


client {
  enabled = true
  servers = ["127.0.0.1"]
}


ui {
  enabled =  true

  #content_security_policy {
  #  connect_src     = ["*"]
  #  default_src     = ["'none'"]
  #  form_action     = ["'none'"]
  #  frame_ancestors = ["'none'"]
  #  img_src         = ["'self'","data:"]
  #  script_src      = ["'self'"]
  #  style_src       = ["'self'","'unsafe-inline'"]
  #}

  consul {
    ui_url = "https://NOMADIC_ONE_IP:8501/ui"
  }

  label {
    text             = "NomadAI"
    background_color = "green"
    text_color       = "#000000"
  }
}
