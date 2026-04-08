output "arn" {
  description = "Computed ARN of the Route53 Resolver Endpoint."
  value       = data.aws_route53_resolver_endpoint.this.arn
}

output "direction" {
  description = "Direction of the queries to or from the Resolver Endpoint."
  value       = data.aws_route53_resolver_endpoint.this.direction
}

output "ip_addresses" {
  description = "List of IP addresses that have been associated with the Resolver Endpoint."
  value       = data.aws_route53_resolver_endpoint.this.ip_addresses
}

output "protocols" {
  description = "The protocols used by the Resolver endpoint."
  value       = data.aws_route53_resolver_endpoint.this.protocols
}

output "resolver_endpoint_type" {
  description = "The Resolver endpoint IP address type."
  value       = data.aws_route53_resolver_endpoint.this.resolver_endpoint_type
}

output "status" {
  description = "Current status of the Resolver Endpoint."
  value       = data.aws_route53_resolver_endpoint.this.status
}

output "vpc_id" {
  description = "ID of the Host VPC that the Resolver Endpoint resides in."
  value       = data.aws_route53_resolver_endpoint.this.vpc_id
}