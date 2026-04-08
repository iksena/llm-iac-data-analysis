output "public_ip" {
  description = "Public IP to ssh."
  value       = aws_instance.project_centos.public_ip
}

