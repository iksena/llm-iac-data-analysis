output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_networkfirewall_vpc_endpoint_association.this.tags_all
}

output "vpc_endpoint_association_arn" {
  description = "ARN of the VPC Endpoint Association"
  value       = aws_networkfirewall_vpc_endpoint_association.this.vpc_endpoint_association_arn
}

output "vpc_endpoint_association_id" {
  description = "The unique identifier of the VPC endpoint association"
  value       = aws_networkfirewall_vpc_endpoint_association.this.vpc_endpoint_association_id
}

output "vpc_endpoint_association_status" {
  description = "Nested list of information about the current status of the VPC Endpoint Association"
  value       = aws_networkfirewall_vpc_endpoint_association.this.vpc_endpoint_association_status
}