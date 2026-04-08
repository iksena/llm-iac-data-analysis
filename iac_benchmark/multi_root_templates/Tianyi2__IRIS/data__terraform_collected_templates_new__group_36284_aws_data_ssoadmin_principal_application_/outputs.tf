output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_ssoadmin_principal_application_assignments.this.region
}

output "instance_arn" {
  description = "ARN of the instance of IAM Identity Center."
  value       = data.aws_ssoadmin_principal_application_assignments.this.instance_arn
}

output "principal_id" {
  description = "An identifier for an object in IAM Identity Center, such as a user or group."
  value       = data.aws_ssoadmin_principal_application_assignments.this.principal_id
}

output "principal_type" {
  description = "Entity type for which the assignment will be created."
  value       = data.aws_ssoadmin_principal_application_assignments.this.principal_type
}

output "application_assignments" {
  description = "List of principals assigned to the application."
  value       = data.aws_ssoadmin_principal_application_assignments.this.application_assignments
}