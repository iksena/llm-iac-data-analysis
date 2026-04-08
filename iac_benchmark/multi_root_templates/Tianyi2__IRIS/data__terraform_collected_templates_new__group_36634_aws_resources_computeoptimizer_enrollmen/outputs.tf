output "region" {
  description = "Region where this resource is managed."
  value       = aws_computeoptimizer_enrollment_status.this.region
}

output "include_member_accounts" {
  description = "Whether member accounts of the organization are enrolled."
  value       = aws_computeoptimizer_enrollment_status.this.include_member_accounts
}

output "status" {
  description = "The enrollment status of the account."
  value       = aws_computeoptimizer_enrollment_status.this.status
}

output "number_of_member_accounts_opted_in" {
  description = "The count of organization member accounts that are opted in to the service, if your account is an organization management account."
  value       = aws_computeoptimizer_enrollment_status.this.number_of_member_accounts_opted_in
}