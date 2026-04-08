output "arn" {
  description = "The Organizations ARN for the delegate account"
  value       = aws_vpc_ipam_organization_admin_account.this.arn
}

output "id" {
  description = "The Organizations member account ID that you want to enable as the IPAM account"
  value       = aws_vpc_ipam_organization_admin_account.this.id
}

output "email" {
  description = "The Organizations email for the delegate account"
  value       = aws_vpc_ipam_organization_admin_account.this.email
}

output "name" {
  description = "The Organizations name for the delegate account"
  value       = aws_vpc_ipam_organization_admin_account.this.name
}

output "service_principal" {
  description = "The AWS service principal"
  value       = aws_vpc_ipam_organization_admin_account.this.service_principal
}