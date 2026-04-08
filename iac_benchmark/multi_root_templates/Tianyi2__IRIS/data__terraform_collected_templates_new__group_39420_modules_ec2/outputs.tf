output "instance_ids" {
  description = "EC2 instance IDs"
  value       = aws_instance.web[*].id
}

output "instance_private_ips" {
  description = "Private IP addresses of instances"
  value       = aws_instance.web[*].private_ip
}
