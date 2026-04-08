output "id" {
  description = "The identifier of the instance."
  value       = aws_connect_instance.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the instance."
  value       = aws_connect_instance.this.arn
}

output "created_time" {
  description = "When the instance was created."
  value       = aws_connect_instance.this.created_time
}

output "service_role" {
  description = "The service role of the instance."
  value       = aws_connect_instance.this.service_role
}

output "status" {
  description = "The state of the instance."
  value       = aws_connect_instance.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_connect_instance.this.tags_all
}