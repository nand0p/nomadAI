data "aws_caller_identity" "current" {}

resource "aws_security_group" "nomad_ai_cluster" {
  count       = var.nomad_ai_security_group_id == "" ? 1 : 0
  name        = "nomad_ai_cluster"
  description = "nomad_ai cluster instances"
  vpc_id      = local.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = local.tags
}

resource "aws_security_group_rule" "allow_ssh" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_nomad" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 4646
  to_port           = 4648
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_serf_tcp" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8300
  to_port           = 8302
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_serf_udp" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8301
  to_port           = 8302
  protocol          = "udp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_gossip_udp" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 7301
  to_port           = 7301
  protocol          = "udp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_gossip_tcp" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 7300
  to_port           = 7301
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_api" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8500
  to_port           = 8502
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_dns_tcp" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_consul_dns_udp" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 8600
  to_port           = 8600
  protocol          = "udp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_http" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_https" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_security_group_rule" "allow_docker_ephemeral" {
  count             = var.nomad_ai_security_group_id == "" ? 1 : 0
  type              = "ingress"
  from_port         = 20000
  to_port           = 32000
  protocol          = "tcp"
  security_group_id = aws_security_group.nomad_ai_cluster[0].id
  cidr_blocks       = var.trusted_cidrs
}

resource "aws_iam_instance_profile" "nomad_ai" {
  count = var.nomad_ai_instance_profile_name == "" ? 1 : 0
  name  = var.stack_name
  role  = aws_iam_role.nomad_ai[0].name
}

resource "aws_iam_role" "nomad_ai" {
  count              = var.nomad_ai_instance_profile_name == "" ? 1 : 0
  name               = var.stack_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.nomad_ai.json
  tags               = local.tags
}

data "aws_iam_policy_document" "nomad_ai" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy" "nomad_ai" {
  count  = var.nomad_ai_instance_profile_name == "" ? 1 : 0
  name   = var.stack_name
  role   = aws_iam_role.nomad_ai[0].name
  policy = file("${abspath(path.root)}/nomad_ai_iam_policy.json")
}


resource "tls_private_key" "nomad_ai_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "nomad_ai_key" {
  key_name   = "nomad_ai_key"
  public_key = tls_private_key.nomad_ai_key.public_key_openssh
}

resource "aws_ssm_parameter" "nomad_ai_instance_ids" {
  name      = "nomad_ai_instance_ids"
  type      = "String"
  value     = "${aws_instance.nomad_ai_one.id},${aws_instance.nomad_ai_two.id},${aws_instance.nomad_ai_three.id}"
}

resource "local_file" "ssh_key" {
  filename             = "${local.ssh_path}/${aws_key_pair.nomad_ai_key.key_name}.pem"
  content              = tls_private_key.nomad_ai_key.private_key_pem
  file_permission      = "0400"
  directory_permission = "0775"
}

resource "aws_ssm_parameter" "nomad_ai_key" {
  name      = "nomad_ai_key"
  type      = "String"
  value     = tls_private_key.nomad_ai_key.private_key_pem
}
