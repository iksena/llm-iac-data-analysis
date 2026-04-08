output "id" {
  description = "The standard control ARN."
  value       = aws_securityhub_standards_control.this.id
}

output "control_id" {
  description = "The identifier of the security standard control."
  value       = aws_securityhub_standards_control.this.control_id
}

output "control_status_updated_at" {
  description = "The date and time that the status of the security standard control was most recently updated."
  value       = aws_securityhub_standards_control.this.control_status_updated_at
}

output "description" {
  description = "The standard control longer description. Provides information about what the control is checking for."
  value       = aws_securityhub_standards_control.this.description
}

output "related_requirements" {
  description = "The list of requirements that are related to this control."
  value       = aws_securityhub_standards_control.this.related_requirements
}

output "remediation_url" {
  description = "A link to remediation information for the control in the Security Hub user documentation."
  value       = aws_securityhub_standards_control.this.remediation_url
}

output "severity_rating" {
  description = "The severity of findings generated from this security standard control."
  value       = aws_securityhub_standards_control.this.severity_rating
}

output "title" {
  description = "The standard control title."
  value       = aws_securityhub_standards_control.this.title
}