output "arn" {
  description = "Amazon Resource Name (ARN) of the GuardDuty IPSet."
  value       = aws_guardduty_ipset.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_guardduty_ipset.this.tags_all
}