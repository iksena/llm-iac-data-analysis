output "arn" {
  description = "The Amazon Resource Name (ARN) of the delegated administrator's account."
  value       = aws_cloudtrail_organization_delegated_admin_account.this.arn
}

output "email" {
  description = "The email address that is associated with the delegated administrator's AWS account."
  value       = aws_cloudtrail_organization_delegated_admin_account.this.email
}

output "name" {
  description = "The friendly name of the delegated administrator's account."
  value       = aws_cloudtrail_organization_delegated_admin_account.this.name
}

output "service_principal" {
  description = "The AWS CloudTrail service principal name."
  value       = aws_cloudtrail_organization_delegated_admin_account.this.service_principal
}