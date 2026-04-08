output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the created activity"
  value       = aws_sfn_activity.this.id
}

output "name" {
  description = "The name of the activity"
  value       = aws_sfn_activity.this.name
}

output "creation_date" {
  description = "The date the activity was created"
  value       = aws_sfn_activity.this.creation_date
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_sfn_activity.this.tags_all
}