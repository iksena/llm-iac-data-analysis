output "arn" {
  description = "ARN of the connection"
  value       = aws_apprunner_connection.this.arn
}

output "status" {
  description = "Current state of the App Runner connection"
  value       = aws_apprunner_connection.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_apprunner_connection.this.tags_all
}