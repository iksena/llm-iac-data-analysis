output "id" {
  description = "The ID of the firewall configuration."
  value       = aws_route53_resolver_firewall_config.this.id
}

output "owner_id" {
  description = "The AWS account ID of the owner of the VPC that this firewall configuration applies to."
  value       = aws_route53_resolver_firewall_config.this.owner_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_route53_resolver_firewall_config.this.region
}

output "resource_id" {
  description = "The ID of the VPC that the configuration is for."
  value       = aws_route53_resolver_firewall_config.this.resource_id
}

output "firewall_fail_open" {
  description = "How Route 53 Resolver handles queries during failures."
  value       = aws_route53_resolver_firewall_config.this.firewall_fail_open
}