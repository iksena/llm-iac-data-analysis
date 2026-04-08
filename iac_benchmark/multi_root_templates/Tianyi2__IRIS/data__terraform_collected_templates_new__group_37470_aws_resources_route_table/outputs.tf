output "id" {
  description = "The ID of the routing table."
  value       = aws_route_table.this.id
}

output "arn" {
  description = "The ARN of the route table."
  value       = aws_route_table.this.arn
}

output "owner_id" {
  description = "The ID of the AWS account that owns the route table."
  value       = aws_route_table.this.owner_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_route_table.this.tags_all
}