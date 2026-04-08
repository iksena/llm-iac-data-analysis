output "id" {
  description = "The identifier of the Account Assignment i.e., principal_id, principal_type, target_id, target_type, permission_set_arn, instance_arn separated by commas (,)."
  value       = aws_ssoadmin_account_assignment.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssoadmin_account_assignment.this.region
}

output "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance."
  value       = aws_ssoadmin_account_assignment.this.instance_arn
}

output "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  value       = aws_ssoadmin_account_assignment.this.permission_set_arn
}

output "principal_id" {
  description = "An identifier for an object in SSO, such as a user or group."
  value       = aws_ssoadmin_account_assignment.this.principal_id
}

output "principal_type" {
  description = "The entity type for which the assignment was created."
  value       = aws_ssoadmin_account_assignment.this.principal_type
}

output "target_id" {
  description = "An AWS account identifier."
  value       = aws_ssoadmin_account_assignment.this.target_id
}

output "target_type" {
  description = "The entity type for which the assignment was created."
  value       = aws_ssoadmin_account_assignment.this.target_type
}