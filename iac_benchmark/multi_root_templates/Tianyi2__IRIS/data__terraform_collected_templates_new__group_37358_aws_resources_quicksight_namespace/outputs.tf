output "arn" {
  description = "ARN of the Namespace."
  value       = aws_quicksight_namespace.this.arn
}

output "capacity_region" {
  description = "Namespace AWS Region."
  value       = aws_quicksight_namespace.this.capacity_region
}

output "creation_status" {
  description = "Creation status of the namespace."
  value       = aws_quicksight_namespace.this.creation_status
}

output "id" {
  description = "A comma-delimited string joining AWS account ID and namespace."
  value       = aws_quicksight_namespace.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_quicksight_namespace.this.tags_all
}