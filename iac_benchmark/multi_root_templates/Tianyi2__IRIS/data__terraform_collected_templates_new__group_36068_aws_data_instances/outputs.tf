output "id" {
  description = "AWS Region."
  value       = data.aws_instances.this.id
}

output "ids" {
  description = "IDs of instances found through the filter."
  value       = data.aws_instances.this.ids
}

output "private_ips" {
  description = "Private IP addresses of instances found through the filter."
  value       = data.aws_instances.this.private_ips
}

output "public_ips" {
  description = "Public IP addresses of instances found through the filter."
  value       = data.aws_instances.this.public_ips
}

output "ipv6_addresses" {
  description = "IPv6 addresses of instances found through the filter."
  value       = data.aws_instances.this.ipv6_addresses
}