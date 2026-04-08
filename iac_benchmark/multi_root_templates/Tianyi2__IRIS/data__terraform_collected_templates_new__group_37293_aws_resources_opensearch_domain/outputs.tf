output "arn" {
  description = "ARN of the domain"
  value       = aws_opensearch_domain.this.arn
}

output "domain_endpoint_v2_hosted_zone_id" {
  description = "Dual stack hosted zone ID for the domain"
  value       = aws_opensearch_domain.this.domain_endpoint_v2_hosted_zone_id
}

output "domain_id" {
  description = "Unique identifier for the domain"
  value       = aws_opensearch_domain.this.domain_id
}

output "domain_name" {
  description = "Name of the OpenSearch domain"
  value       = aws_opensearch_domain.this.domain_name
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests"
  value       = aws_opensearch_domain.this.endpoint
}

output "endpoint_v2" {
  description = "V2 domain endpoint that works with both IPv4 and IPv6 addresses, used to submit index, search, and data upload requests"
  value       = aws_opensearch_domain.this.endpoint_v2
}

output "dashboard_endpoint" {
  description = "Domain-specific endpoint for Dashboard without https scheme"
  value       = aws_opensearch_domain.this.dashboard_endpoint
}

output "dashboard_endpoint_v2" {
  description = "V2 domain endpoint for Dashboard that works with both IPv4 and IPv6 addresses, without https scheme"
  value       = aws_opensearch_domain.this.dashboard_endpoint_v2
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_opensearch_domain.this.tags_all
}

output "vpc_options_availability_zones" {
  description = "If the domain was created inside a VPC, the names of the availability zones the configured subnet_ids were created inside"
  value       = try(aws_opensearch_domain.this.vpc_options[0].availability_zones, null)
}

output "vpc_options_vpc_id" {
  description = "If the domain was created inside a VPC, the ID of the VPC"
  value       = try(aws_opensearch_domain.this.vpc_options[0].vpc_id, null)
}