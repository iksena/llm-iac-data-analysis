output "id" {
  description = "Identifier for the organization administrator account"
  value       = aws_auditmanager_organization_admin_account_registration.this.id
}

output "organization_id" {
  description = "Identifier for the organization"
  value       = aws_auditmanager_organization_admin_account_registration.this.organization_id
}