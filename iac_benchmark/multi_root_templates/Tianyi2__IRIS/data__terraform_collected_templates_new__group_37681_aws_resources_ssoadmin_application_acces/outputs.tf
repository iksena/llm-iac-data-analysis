output "id" {
  description = "A comma-delimited string concatenating application_arn and scope"
  value       = aws_ssoadmin_application_access_scope.this.id
}

output "application_arn" {
  description = "The ARN of the application with the access scope"
  value       = aws_ssoadmin_application_access_scope.this.application_arn
}

output "scope" {
  description = "The name of the access scope"
  value       = aws_ssoadmin_application_access_scope.this.scope
}

output "authorized_targets" {
  description = "The array list of ARNs that represent the authorized targets for this access scope"
  value       = aws_ssoadmin_application_access_scope.this.authorized_targets
}

output "region" {
  description = "The region where this resource is managed"
  value       = aws_ssoadmin_application_access_scope.this.region
}