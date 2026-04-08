output "arn" {
  description = "The ARN of the configured table"
  value       = aws_cleanrooms_configured_table.this.arn
}

output "id" {
  description = "The ID of the configured table"
  value       = aws_cleanrooms_configured_table.this.id
}

output "create_time" {
  description = "The date and time the configured table was created"
  value       = aws_cleanrooms_configured_table.this.create_time
}

output "update_time" {
  description = "The date and time the configured table was last updated"
  value       = aws_cleanrooms_configured_table.this.update_time
}