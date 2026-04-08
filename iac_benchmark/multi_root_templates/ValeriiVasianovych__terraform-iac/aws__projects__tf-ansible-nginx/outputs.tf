output "region" {
  value = var.region
}

output "aws_caller_identity" {
    value = data.aws_caller_identity.current.id
}

output "vpc_id" {
  value = local.vpc_id
}

output "instance_id" {
  value = aws_instance.webserver.id
}

output "instance_public_ip" {
  value = aws_instance.webserver.public_ip
}