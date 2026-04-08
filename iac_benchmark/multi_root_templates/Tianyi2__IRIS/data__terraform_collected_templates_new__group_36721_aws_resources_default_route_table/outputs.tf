output "id" {
  description = "ID of the route table."
  value       = aws_default_route_table.this.id
}

output "arn" {
  description = "The ARN of the route table."
  value       = aws_default_route_table.this.arn
}

output "owner_id" {
  description = "ID of the AWS account that owns the route table."
  value       = aws_default_route_table.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_default_route_table.this.tags_all
}

output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_default_route_table.this.vpc_id
}