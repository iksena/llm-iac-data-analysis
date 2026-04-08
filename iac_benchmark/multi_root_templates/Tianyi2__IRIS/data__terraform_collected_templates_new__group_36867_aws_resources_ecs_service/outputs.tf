output "arn" {
  description = "ARN that identifies the service"
  value       = aws_ecs_service.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_ecs_service.this.tags_all
}