output "region" {
  description = "Region where the resource is managed"
  value       = aws_guardduty_member_detector_feature.this.region
}

output "detector_id" {
  description = "Amazon GuardDuty detector ID"
  value       = aws_guardduty_member_detector_feature.this.detector_id
}

output "account_id" {
  description = "Member account ID"
  value       = aws_guardduty_member_detector_feature.this.account_id
}

output "name" {
  description = "The name of the detector feature"
  value       = aws_guardduty_member_detector_feature.this.name
}

output "status" {
  description = "The status of the detector feature"
  value       = aws_guardduty_member_detector_feature.this.status
}

output "additional_configuration" {
  description = "Additional feature configuration"
  value       = aws_guardduty_member_detector_feature.this.additional_configuration
}