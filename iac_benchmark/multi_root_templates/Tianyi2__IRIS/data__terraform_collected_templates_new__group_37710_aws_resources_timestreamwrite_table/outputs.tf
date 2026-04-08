output "id" {
  description = "The table_name and database_name separated by a colon (:)."
  value       = aws_timestreamwrite_table.this.id
}

output "arn" {
  description = "The ARN that uniquely identifies this table."
  value       = aws_timestreamwrite_table.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_timestreamwrite_table.this.tags_all
}