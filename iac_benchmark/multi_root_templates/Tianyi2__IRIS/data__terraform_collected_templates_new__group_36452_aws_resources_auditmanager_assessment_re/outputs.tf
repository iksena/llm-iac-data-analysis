output "author" {
  description = "Name of the user who created the assessment report."
  value       = aws_auditmanager_assessment_report.this.author
}

output "id" {
  description = "Unique identifier for the assessment report."
  value       = aws_auditmanager_assessment_report.this.id
}

output "status" {
  description = "Current status of the specified assessment report. Valid values are COMPLETE, IN_PROGRESS, and FAILED."
  value       = aws_auditmanager_assessment_report.this.status
}