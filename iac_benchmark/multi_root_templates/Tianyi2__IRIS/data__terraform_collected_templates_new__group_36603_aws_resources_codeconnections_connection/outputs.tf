output "arn" {
  description = "The codeconnections connection ARN."
  value       = aws_codeconnections_connection.this.arn
}

output "connection_status" {
  description = "The codeconnections connection status. Possible values are PENDING, AVAILABLE and ERROR."
  value       = aws_codeconnections_connection.this.connection_status
}

output "id" {
  description = "The codeconnections connection ARN (deprecated, use arn instead)."
  value       = aws_codeconnections_connection.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codeconnections_connection.this.tags_all
}