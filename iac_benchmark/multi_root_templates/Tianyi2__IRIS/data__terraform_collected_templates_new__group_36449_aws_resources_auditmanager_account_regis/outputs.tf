output "id" {
  description = "Unique identifier for the account registration. Since registration is applied per AWS region, this will be the active region name (ex. us-east-1)."
  value       = aws_auditmanager_account_registration.this.id
}

output "status" {
  description = "Status of the account registration request."
  value       = aws_auditmanager_account_registration.this.status
}