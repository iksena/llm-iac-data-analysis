output "application_assignments" {
  description = "List of principals assigned to the application."
  value       = data.aws_ssoadmin_application_assignments.this.application_assignments
}

output "application_arn" {
  description = "ARN of the application."
  value       = data.aws_ssoadmin_application_assignments.this.application_arn
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_ssoadmin_application_assignments.this.region
}