output "id" {
  description = "The ID of the GuardDuty publishing destination."
  value       = aws_guardduty_publishing_destination.this.id
}


output "detector_id" {
  description = "The detector ID of the GuardDuty."
  value       = aws_guardduty_publishing_destination.this.detector_id
}

output "destination_arn" {
  description = "The bucket ARN and prefix under which the findings get exported."
  value       = aws_guardduty_publishing_destination.this.destination_arn
}

output "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt GuardDuty findings."
  value       = aws_guardduty_publishing_destination.this.kms_key_arn
}

output "destination_type" {
  description = "The destination type for the GuardDuty publishing destination."
  value       = aws_guardduty_publishing_destination.this.destination_type
}