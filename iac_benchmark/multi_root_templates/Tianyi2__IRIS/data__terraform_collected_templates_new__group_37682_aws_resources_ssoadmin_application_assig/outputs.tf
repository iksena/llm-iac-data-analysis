output "id" {
  description = "A comma-delimited string concatenating application_arn, principal_id, and principal_type"
  value       = aws_ssoadmin_application_assignment.this.id
}

output "application_arn" {
  description = "ARN of the application"
  value       = aws_ssoadmin_application_assignment.this.application_arn
}

output "principal_id" {
  description = "An identifier for an object in IAM Identity Center, such as a user or group"
  value       = aws_ssoadmin_application_assignment.this.principal_id
}

output "principal_type" {
  description = "Entity type for which the assignment will be created"
  value       = aws_ssoadmin_application_assignment.this.principal_type
}