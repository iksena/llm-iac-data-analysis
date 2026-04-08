output "delegation_id" {
  description = "Unique identifier for the delegation."
  value       = aws_auditmanager_assessment_delegation.this.delegation_id
}

output "id" {
  description = "Unique identifier for the resource. This is a comma-separated string containing assessment_id, role_arn, and control_set_id."
  value       = aws_auditmanager_assessment_delegation.this.id
}

output "status" {
  description = "Status of the delegation."
  value       = aws_auditmanager_assessment_delegation.this.status
}