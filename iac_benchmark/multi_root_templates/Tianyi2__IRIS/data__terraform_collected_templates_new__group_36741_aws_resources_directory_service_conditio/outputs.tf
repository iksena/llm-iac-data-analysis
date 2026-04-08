output "directory_id" {
  description = "ID of the directory"
  value       = aws_directory_service_conditional_forwarder.this.directory_id
}

output "dns_ips" {
  description = "List of forwarder IP addresses"
  value       = aws_directory_service_conditional_forwarder.this.dns_ips
}

output "remote_domain_name" {
  description = "The fully qualified domain name of the remote domain"
  value       = aws_directory_service_conditional_forwarder.this.remote_domain_name
}