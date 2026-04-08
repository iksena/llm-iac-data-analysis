output "arn" {
  description = "ARN of the detector."
  value       = data.aws_guardduty_detector.this.arn
}

output "features" {
  description = "Current configuration of the detector features."
  value       = data.aws_guardduty_detector.this.features
}

output "finding_publishing_frequency" {
  description = "The frequency of notifications sent about subsequent finding occurrences."
  value       = data.aws_guardduty_detector.this.finding_publishing_frequency
}

output "service_role_arn" {
  description = "Service-linked role that grants GuardDuty access to the resources in the AWS account."
  value       = data.aws_guardduty_detector.this.service_role_arn
}

output "status" {
  description = "Current status of the detector."
  value       = data.aws_guardduty_detector.this.status
}

output "tags" {
  description = "Map of tags for the resource."
  value       = data.aws_guardduty_detector.this.tags
}