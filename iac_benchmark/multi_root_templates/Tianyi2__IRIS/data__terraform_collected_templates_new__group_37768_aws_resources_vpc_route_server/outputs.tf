output "arn" {
  description = "The ARN of the route server."
  value       = aws_vpc_route_server.this.arn
}

output "route_server_id" {
  description = "The unique identifier of the route server."
  value       = aws_vpc_route_server.this.route_server_id
}

output "sns_topic_arn" {
  description = "The ARN of the SNS topic where notifications are published."
  value       = aws_vpc_route_server.this.sns_topic_arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_vpc_route_server.this.tags_all
}