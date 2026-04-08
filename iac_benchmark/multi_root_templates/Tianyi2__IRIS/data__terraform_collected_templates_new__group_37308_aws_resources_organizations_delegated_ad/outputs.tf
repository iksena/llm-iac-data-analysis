output "id" {
  description = "The unique identifier (ID) of the delegated administrator"
  value       = aws_organizations_delegated_administrator.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the delegated administrator's account"
  value       = aws_organizations_delegated_administrator.this.arn
}

output "delegation_enabled_date" {
  description = "The date when the account was made a delegated administrator"
  value       = aws_organizations_delegated_administrator.this.delegation_enabled_date
}

output "email" {
  description = "The email address that is associated with the delegated administrator's AWS account"
  value       = aws_organizations_delegated_administrator.this.email
}

output "joined_method" {
  description = "The method by which the delegated administrator's account joined the organization"
  value       = aws_organizations_delegated_administrator.this.joined_method
}

output "joined_timestamp" {
  description = "The date when the delegated administrator's account became a part of the organization"
  value       = aws_organizations_delegated_administrator.this.joined_timestamp
}

output "name" {
  description = "The friendly name of the delegated administrator's account"
  value       = aws_organizations_delegated_administrator.this.name
}

output "status" {
  description = "The status of the delegated administrator's account in the organization"
  value       = aws_organizations_delegated_administrator.this.status
}

output "account_id" {
  description = "The account ID number of the member account in the organization to register as a delegated administrator"
  value       = aws_organizations_delegated_administrator.this.account_id
}

output "service_principal" {
  description = "The service principal of the AWS service for which you want to make the member account a delegated administrator"
  value       = aws_organizations_delegated_administrator.this.service_principal
}