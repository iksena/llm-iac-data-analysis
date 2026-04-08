output "id" {
  description = "The resource ID of the GuardDuty detector feature."
  value       = aws_guardduty_detector_feature.this.id
}

output "region" {
  description = "The AWS region where the detector feature is configured."
  value       = aws_guardduty_detector_feature.this.region
}

output "detector_id" {
  description = "The Amazon GuardDuty detector ID."
  value       = aws_guardduty_detector_feature.this.detector_id
}

output "name" {
  description = "The name of the detector feature."
  value       = aws_guardduty_detector_feature.this.name
}

output "status" {
  description = "The status of the detector feature."
  value       = aws_guardduty_detector_feature.this.status
}

output "additional_configuration" {
  description = "Additional feature configuration for the detector feature."
  value       = aws_guardduty_detector_feature.this.additional_configuration
}