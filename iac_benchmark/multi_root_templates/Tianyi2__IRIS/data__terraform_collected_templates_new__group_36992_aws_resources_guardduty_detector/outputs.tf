output "account_id" {
  description = "The AWS account ID of the GuardDuty detector"
  value       = aws_guardduty_detector.this.account_id
}

output "arn" {
  description = "Amazon Resource Name (ARN) of the GuardDuty detector"
  value       = aws_guardduty_detector.this.arn
}

output "id" {
  description = "The ID of the GuardDuty detector"
  value       = aws_guardduty_detector.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_guardduty_detector.this.tags_all
}