output "arn" {
  description = "The ARN of the type."
  value       = aws_appsync_type.this.arn
}

output "description" {
  description = "The type description."
  value       = aws_appsync_type.this.description
}

output "id" {
  description = "The ID is constructed from api-id:format:name."
  value       = aws_appsync_type.this.id
}

output "name" {
  description = "The type name."
  value       = aws_appsync_type.this.name
}