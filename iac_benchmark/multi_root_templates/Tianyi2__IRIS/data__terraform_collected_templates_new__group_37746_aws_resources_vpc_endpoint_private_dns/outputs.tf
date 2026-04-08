
output "vpc_endpoint_id" {
  description = "VPC endpoint identifier"
  value       = aws_vpc_endpoint_private_dns.this.vpc_endpoint_id
}

output "private_dns_enabled" {
  description = "Indicates whether a private hosted zone is associated with the VPC"
  value       = aws_vpc_endpoint_private_dns.this.private_dns_enabled
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_vpc_endpoint_private_dns.this.region
}