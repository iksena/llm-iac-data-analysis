output "id" {
  description = "Policy Name, Policy Path, Permission Set Amazon Resource Name (ARN), and SSO Instance ARN, each separated by a comma (,)."
  value       = aws_ssoadmin_customer_managed_policy_attachment.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ssoadmin_customer_managed_policy_attachment.this.region
}

output "instance_arn" {
  description = "The Amazon Resource Name (ARN) of the SSO Instance under which the operation will be executed."
  value       = aws_ssoadmin_customer_managed_policy_attachment.this.instance_arn
}

output "permission_set_arn" {
  description = "The Amazon Resource Name (ARN) of the Permission Set."
  value       = aws_ssoadmin_customer_managed_policy_attachment.this.permission_set_arn
}

output "customer_managed_policy_reference" {
  description = "Customer managed policy reference configuration."
  value = {
    name = aws_ssoadmin_customer_managed_policy_attachment.this.customer_managed_policy_reference[0].name
    path = aws_ssoadmin_customer_managed_policy_attachment.this.customer_managed_policy_reference[0].path
  }
}