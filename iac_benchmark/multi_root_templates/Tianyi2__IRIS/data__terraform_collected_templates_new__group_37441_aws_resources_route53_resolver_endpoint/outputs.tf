output "arn" {
  description = "ARN of the Route 53 Resolver endpoint."
  value       = aws_route53_resolver_endpoint.this.arn
}

output "host_vpc_id" {
  description = "ID of the VPC that you want to create the resolver endpoint in."
  value       = aws_route53_resolver_endpoint.this.host_vpc_id
}

output "id" {
  description = "ID of the Route 53 Resolver endpoint."
  value       = aws_route53_resolver_endpoint.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route53_resolver_endpoint.this.tags_all
}