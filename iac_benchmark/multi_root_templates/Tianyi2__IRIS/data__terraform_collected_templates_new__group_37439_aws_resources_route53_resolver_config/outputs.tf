output "id" {
  description = "The ID of the resolver configuration."
  value       = aws_route53_resolver_config.this.id
}

output "owner_id" {
  description = "The AWS account ID of the owner of the VPC that this resolver configuration applies to."
  value       = aws_route53_resolver_config.this.owner_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_route53_resolver_config.this.region
}

output "resource_id" {
  description = "The ID of the VPC that the configuration is for."
  value       = aws_route53_resolver_config.this.resource_id
}

output "autodefined_reverse_flag" {
  description = "Indicates whether or not the Resolver will create autodefined rules for reverse DNS lookups."
  value       = aws_route53_resolver_config.this.autodefined_reverse_flag
}