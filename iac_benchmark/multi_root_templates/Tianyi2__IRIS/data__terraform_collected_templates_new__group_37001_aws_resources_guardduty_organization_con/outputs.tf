output "id" {
  description = "The ID of the GuardDuty organization configuration (same as detector_id)."
  value       = aws_guardduty_organization_configuration.this.id
}

output "detector_id" {
  description = "The detector ID of the GuardDuty account."
  value       = aws_guardduty_organization_configuration.this.detector_id
}

output "auto_enable_organization_members" {
  description = "The auto-enablement configuration of GuardDuty for the member accounts in the organization."
  value       = aws_guardduty_organization_configuration.this.auto_enable_organization_members
}

output "region" {
  description = "The region where this resource is managed."
  value       = aws_guardduty_organization_configuration.this.region
}