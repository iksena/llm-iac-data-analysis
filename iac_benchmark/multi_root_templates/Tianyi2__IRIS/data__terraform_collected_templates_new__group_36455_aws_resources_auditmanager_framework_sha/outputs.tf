output "id" {
  description = "Unique identifier for the share request."
  value       = aws_auditmanager_framework_share.this.id
}

output "status" {
  description = "Status of the share request."
  value       = aws_auditmanager_framework_share.this.status
}