output "id" {
  description = "Amazon Resource Name (ARN) of the DataSync Task"
  value       = aws_datasync_task.this.id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the DataSync Task"
  value       = aws_datasync_task.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_datasync_task.this.tags_all
}