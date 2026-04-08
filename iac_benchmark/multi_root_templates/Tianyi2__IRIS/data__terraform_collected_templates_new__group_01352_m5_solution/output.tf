output "aws_instance_public_dns" {
  description = "Public DNS hostname of the EC2 instance"
  value       = "http://${aws_instance.nginx1.public_dns}:${var.http_port}"
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.app.id
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = aws_subnet.public_subnet1.id
}