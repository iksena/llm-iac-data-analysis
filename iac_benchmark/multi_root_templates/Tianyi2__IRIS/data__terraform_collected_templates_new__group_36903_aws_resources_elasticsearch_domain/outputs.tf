output "arn" {
  description = "ARN of the domain."
  value       = aws_elasticsearch_domain.this.arn
}

output "domain_id" {
  description = "Unique identifier for the domain."
  value       = aws_elasticsearch_domain.this.domain_id
}

output "domain_name" {
  description = "Name of the domain."
  value       = aws_elasticsearch_domain.this.domain_name
}

output "endpoint" {
  description = "Domain-specific endpoint used to submit index, search, and data upload requests."
  value       = aws_elasticsearch_domain.this.endpoint
}

output "kibana_endpoint" {
  description = "Domain-specific endpoint for kibana without https scheme."
  value       = aws_elasticsearch_domain.this.kibana_endpoint
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_elasticsearch_domain.this.tags_all
}

output "vpc_options" {
  description = "VPC options for the domain."
  value = var.vpc_options != null ? {
    availability_zones = aws_elasticsearch_domain.this.vpc_options[0].availability_zones
    vpc_id             = aws_elasticsearch_domain.this.vpc_options[0].vpc_id
    security_group_ids = aws_elasticsearch_domain.this.vpc_options[0].security_group_ids
    subnet_ids         = aws_elasticsearch_domain.this.vpc_options[0].subnet_ids
  } : null
}