output "id" {
  description = "The Amazon Resource Names (ARNs) of the Managed Policy, Permission Set, and SSO Instance, separated by a comma (`,`)."
  value       = aws_ssoadmin_managed_policy_attachment.this.id
}

output "managed_policy_name" {
  description = "The name of the IAM Managed Policy."
  value       = aws_ssoadmin_managed_policy_attachment.this.managed_policy_name
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssoadmin_managed_policy_attachment.this.region
}

output "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  value       = aws_ssoadmin_managed_policy_attachment.this.instance_arn
}

output "managed_policy_arn" {
  description = "The IAM managed policy Amazon Resource Name (ARN) to be attached to the Permission Set."
  value       = aws_ssoadmin_managed_policy_attachment.this.managed_policy_arn
}

output "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  value       = aws_ssoadmin_managed_policy_attachment.this.permission_set_arn
}