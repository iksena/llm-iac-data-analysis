output "arn" {
  description = "Amazon Resource Name (ARN) of the assessment"
  value       = aws_auditmanager_assessment.this.arn
}

output "id" {
  description = "Unique identifier for the assessment"
  value       = aws_auditmanager_assessment.this.id
}

output "roles_all" {
  description = "Complete list of all roles with access to the assessment"
  value       = aws_auditmanager_assessment.this.roles_all
}

output "status" {
  description = "Status of the assessment"
  value       = aws_auditmanager_assessment.this.status
}