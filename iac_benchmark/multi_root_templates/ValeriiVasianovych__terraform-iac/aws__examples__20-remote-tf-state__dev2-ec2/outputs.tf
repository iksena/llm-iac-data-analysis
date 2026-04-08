output "sg_group_id" {
  value = aws_security_group.webserver.id
}

output "webservers_ids" {
  value = aws_instance.ubuntu_webserver[*].id
}

output "aws_instance_public_ip" {
  value = [for i in range(length(aws_instance.ubuntu_webserver)) : aws_instance.ubuntu_webserver[i].public_ip]
}

output "aws_instance_private_ip" {
  value = [for i in range(length(aws_instance.ubuntu_webserver)) : aws_instance.ubuntu_webserver[i].private_ip]
}

output "elastic_ip" {
  value = aws_eip.public_eip[*].public_ip
}

output "eip_ids" {
  value = aws_eip.public_eip[*].id
}