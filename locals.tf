locals { 
  vpc_id                = var.nomad_ai_vpc_id != "" ? var.nomad_ai_vpc_id : aws_vpc.nomad_ai[0].id
  subnet_id             = var.nomad_ai_subnet_id != "" ? var.nomad_ai_subnet_id : aws_subnet.nomad_ai[0].id
  secgroup_id           = var.nomad_ai_security_group_id != "" ? var.nomad_ai_security_group_id : aws_security_group.nomad_ai_cluster[0].id
  instance_profile_name = var.nomad_ai_instance_profile_name != "" ? var.nomad_ai_instance_profile_name : aws_iam_instance_profile.nomad_ai[0].name
  ssh_path              = pathexpand("~/.ssh")

  tags = merge({
    Name        = var.stack_name,
    Environment = var.environment,
    Timestamp   = var.timestamp,
  }, var.tags)
}
