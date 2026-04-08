output "id" {
  description = "The unique identifier of the endpoint"
  value       = aws_elasticsearch_vpc_endpoint.this.id
}

output "endpoint" {
  description = "The connection endpoint ID for connecting to the domain"
  value       = aws_elasticsearch_vpc_endpoint.this.endpoint
}

output "region" {
  description = "Region where this resource is managed"
  value       = aws_elasticsearch_vpc_endpoint.this.region
}

output "domain_arn" {
  description = "The Amazon Resource Name (ARN) of the domain"
  value       = aws_elasticsearch_vpc_endpoint.this.domain_arn
}

output "vpc_options" {
  description = "VPC options including subnets and security groups"
  value       = aws_elasticsearch_vpc_endpoint.this.vpc_options
}