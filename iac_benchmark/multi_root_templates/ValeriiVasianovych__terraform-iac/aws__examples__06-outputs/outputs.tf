output "webserver_public_ip" {
  value = aws_eip.static_ip.public_ip
  description = "The public IP address of the web server"
}

output "webserver_private_ip" {
  value = aws_instance.little_downtime.private_ip
  description = "The private IP address of the web server"
}

output "webserver_id" {
  value = aws_instance.little_downtime.id
  description = "The ID of the web server"
}

output "webserver_ami_id" {
  value = aws_instance.little_downtime.ami
  description = "The AMI ID of the web server"
}

output "webserver_arn" {
  value = aws_instance.little_downtime.arn
  description = "The ARN of the web server"
}

output "sg_info" {
  value = aws_security_group.lifecycle_security_group.name
  description = "The AMI ID of the web server"
}