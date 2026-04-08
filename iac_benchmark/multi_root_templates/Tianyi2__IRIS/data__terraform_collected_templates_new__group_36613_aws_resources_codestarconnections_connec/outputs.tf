output "id" {
  description = "The codestar connection ARN."
  value       = aws_codestarconnections_connection.this.id
}

output "arn" {
  description = "The codestar connection ARN."
  value       = aws_codestarconnections_connection.this.arn
}

output "connection_status" {
  description = "The codestar connection status. Possible values are PENDING, AVAILABLE and ERROR."
  value       = aws_codestarconnections_connection.this.connection_status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codestarconnections_connection.this.tags_all
}