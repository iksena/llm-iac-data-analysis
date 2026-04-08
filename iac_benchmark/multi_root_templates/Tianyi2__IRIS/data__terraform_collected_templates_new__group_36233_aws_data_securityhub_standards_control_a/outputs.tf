output "standards_control_associations" {
  description = "A list that provides the status and other details for each security control that applies to each enabled standard."
  value       = data.aws_securityhub_standards_control_associations.this.standards_control_associations
}

output "association_status" {
  description = "Enablement status of a control in a specific standard."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.association_status]
}

output "related_requirements" {
  description = "List of underlying requirements in the compliance framework related to the standard."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.related_requirements]
}

output "security_control_arn" {
  description = "ARN of the security control."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.security_control_arn]
}

output "security_control_id" {
  description = "ID of the security control."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.security_control_id]
}

output "standards_arn" {
  description = "ARN of the standard."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.standards_arn]
}

output "standards_control_description" {
  description = "Description of the standard."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.standards_control_description]
}

output "standards_control_title" {
  description = "Title of the standard."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.standards_control_title]
}

output "updated_at" {
  description = "Last time that a control's enablement status in a specified standard was updated."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.updated_at]
}

output "updated_reason" {
  description = "Reason for updating a control's enablement status in a specified standard."
  value       = [for sca in data.aws_securityhub_standards_control_associations.this.standards_control_associations : sca.updated_reason]
}