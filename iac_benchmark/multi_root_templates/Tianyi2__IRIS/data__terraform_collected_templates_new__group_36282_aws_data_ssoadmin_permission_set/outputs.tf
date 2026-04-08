output "id" {
  description = "ARN of the Permission Set."
  value       = data.aws_ssoadmin_permission_set.this.id
}

output "arn" {
  description = "ARN of the permission set."
  value       = data.aws_ssoadmin_permission_set.this.arn
}

output "instance_arn" {
  description = "ARN of the SSO Instance associated with the permission set."
  value       = data.aws_ssoadmin_permission_set.this.instance_arn
}

output "name" {
  description = "Name of the SSO Permission Set."
  value       = data.aws_ssoadmin_permission_set.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_ssoadmin_permission_set.this.region
}

output "description" {
  description = "Description of the Permission Set."
  value       = data.aws_ssoadmin_permission_set.this.description
}

output "relay_state" {
  description = "Relay state URL used to redirect users within the application during the federation authentication process."
  value       = data.aws_ssoadmin_permission_set.this.relay_state
}

output "session_duration" {
  description = "Length of time that the application user sessions are valid in the ISO-8601 standard."
  value       = data.aws_ssoadmin_permission_set.this.session_duration
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = data.aws_ssoadmin_permission_set.this.tags
}