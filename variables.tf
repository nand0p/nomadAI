variable "stack_name" {
  type = string
}

variable "tags" {
  type = map(any)
}

variable "allow_public_ip" {
  type        = bool
  description = "Associate public ip with instance"
}

variable "aws_profile" {
  type    = string
}

variable "aws_region" {
  type = string
}

variable "environment" {
  type = string
}

variable "timestamp" {
  type = string
}

variable "trusted_cidrs" {
  type = list(any)
}

variable "key_name" {
  type = string
}

variable "nomad_ai_branch" {
  type = string
}

variable "nomad_version" {
  type = string
}

variable "consul_version" {
  type = string
}

variable "nomad_ai_instance_size" {
  type = string
}

variable "root_volume_type" {
  type = string
}

variable "root_volume_size" {
  type = string
}

variable "nomad_ai_vpc_id" {
  type = string
  default = ""
}

variable "nomad_ai_subnet_id" {
  type = string
  default = ""
}

variable "nomad_ai_security_group_id" {
  type    = string
  default = ""
}

variable "nomad_ai_instance_profile_name" {
  type    = string
  default = ""
}

variable "nomad_ai_vpc_cidr" {
  type = string
  default = ""
}

variable "nomad_ai_subnet_cidr" {
  type    = string
  default = ""
}

variable "nomad_ai_ami_id" {
  type    = string
  default = ""
}
