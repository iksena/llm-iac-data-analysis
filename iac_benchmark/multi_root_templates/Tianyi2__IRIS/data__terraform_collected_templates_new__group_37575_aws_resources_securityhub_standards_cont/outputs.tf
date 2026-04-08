# This resource exports no additional attributes beyond the input arguments
# All outputs are based on the input variables as the resource does not create new attributes

output "association_status" {
  description = "The enablement status of the control in the standard"
  value       = aws_securityhub_standards_control_association.this.association_status
}

output "security_control_id" {
  description = "The unique identifier for the security control"
  value       = aws_securityhub_standards_control_association.this.security_control_id
}

output "standards_arn" {
  description = "The Amazon Resource Name (ARN) of the standard"
  value       = aws_securityhub_standards_control_association.this.standards_arn
}

output "region" {
  description = "The region where this resource is managed"
  value       = aws_securityhub_standards_control_association.this.region
}

output "updated_reason" {
  description = "The reason for updating the control's enablement status"
  value       = aws_securityhub_standards_control_association.this.updated_reason
}