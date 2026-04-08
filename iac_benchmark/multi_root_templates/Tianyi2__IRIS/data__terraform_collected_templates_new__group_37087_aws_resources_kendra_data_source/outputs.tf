output "arn" {
  description = "ARN of the Data Source."
  value       = aws_kendra_data_source.this.arn
}

output "created_at" {
  description = "The Unix time stamp of when the Data Source was created."
  value       = aws_kendra_data_source.this.created_at
}

output "data_source_id" {
  description = "The unique identifiers of the Data Source."
  value       = aws_kendra_data_source.this.data_source_id
}

output "error_message" {
  description = "When the Status field value is FAILED, contains a description of the error that caused the Data Source to fail."
  value       = aws_kendra_data_source.this.error_message
}

output "id" {
  description = "The unique identifiers of the Data Source and index separated by a slash (/)."
  value       = aws_kendra_data_source.this.id
}

output "status" {
  description = "The current status of the Data Source. When the status is ACTIVE the Data Source is ready to use. When the status is FAILED, the error_message field contains the reason that the Data Source failed."
  value       = aws_kendra_data_source.this.status
}

output "updated_at" {
  description = "The Unix time stamp of when the Data Source was last updated."
  value       = aws_kendra_data_source.this.updated_at
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_kendra_data_source.this.tags_all
}