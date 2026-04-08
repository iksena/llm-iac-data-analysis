output "id" {
  description = "The ID of the GuardDuty organization configuration feature."
  value       = aws_guardduty_organization_configuration_feature.this.id
}

output "region" {
  description = "The AWS region where the resource is managed."
  value       = aws_guardduty_organization_configuration_feature.this.region
}

output "auto_enable" {
  description = "The status of the feature that is configured for the member accounts within the organization."
  value       = aws_guardduty_organization_configuration_feature.this.auto_enable
}

output "detector_id" {
  description = "The ID of the detector that configures the delegated administrator."
  value       = aws_guardduty_organization_configuration_feature.this.detector_id
}

output "name" {
  description = "The name of the feature that is configured for the organization."
  value       = aws_guardduty_organization_configuration_feature.this.name
}

output "additional_configuration" {
  description = "Additional feature configuration for the organization."
  value       = aws_guardduty_organization_configuration_feature.this.additional_configuration
}