tags = {
  Product = "NomadAI"
  Owner = "HEX7"
}

stack_name            = "NomadAI"
environment           = "Production"
aws_profile           = "nomadic"
aws_region            = "eu-west-3"
timestamp             = "January2024"
root_volume_type      = "standard"
root_volume_size      = "20"
nomad_ai_instance_size = "t3a.small"
key_name              = "nomad_ai_key"
allow_public_ip       = true
trusted_cidrs = [
  "83.51.158.68/32",
]



# nomad_ai_ami_id = ami-0ebc281c20e89ba4b  #  amzn linuz paris 2018.03 

nomad_ai_branch = "master"
consul_version = "1.17.1"
nomad_version  = "1.7.3"

nomad_ai_vpc_cidr         = "192.168.216.0/24"
nomad_ai_subnet_cidr      = "192.168.216.0/24"

# following below must be set empty to force resource creation
# otherwise, these can be set to existing values
nomad_ai_vpc_id                = ""
nomad_ai_subnet_id             = ""
nomad_ai_instance_profile_name = ""
nomad_ai_security_group_id     = ""
nomad_ai_ami_id                = ""
