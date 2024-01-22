output "nomad_ai_one_instance_id" {
  value = aws_instance.nomad_ai_one.id
}

output "nomad_ai_two_instance_id" {
  value = aws_instance.nomad_ai_two.id
}

output "nomad_ai_three_instance_id" {
  value = aws_instance.nomad_ai_three.id
}

output "nomad_ai_one_private_ip" {
  value = aws_instance.nomad_ai_one.private_ip
}

output "nomad_ai_two_private_ip" {
  value = aws_instance.nomad_ai_two.private_ip
}

output "nomad_ai_three_private_ip" {
  value = aws_instance.nomad_ai_three.private_ip
}

output "tags" {
  value = local.tags
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "aws_caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "aws_caller_user" {
  value = data.aws_caller_identity.current.user_id
}

output "nomad_ai_one_public_ip" {
  value = aws_instance.nomad_ai_one.public_ip
}

output "nomad_ai_two_public_ip" {
  value = aws_instance.nomad_ai_two.public_ip
}

output "nomad_ai_three_public_ip" {
  value = aws_instance.nomad_ai_three.public_ip
}

output "nomad_ai_public_ips" {
  value = "ONE: ${aws_instance.nomad_ai_one.public_ip} TWO: ${aws_instance.nomad_ai_two.public_ip} THREE: ${aws_instance.nomad_ai_three.public_ip}"
}

output "ssh_cmd" {
  value = "ssh -i ${local.ssh_path}/nomad_ai_key.pem ec2-user@${aws_instance.nomad_ai_one.public_ip}"
}

output "consul_ui" {
  value = "http://${aws_instance.nomad_ai_one.public_ip}:8500/ui/"
}
