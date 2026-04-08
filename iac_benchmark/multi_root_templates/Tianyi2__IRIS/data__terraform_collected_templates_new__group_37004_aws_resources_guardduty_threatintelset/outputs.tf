output "arn" {
  description = "Amazon Resource Name (ARN) of the GuardDuty ThreatIntelSet"
  value       = aws_guardduty_threatintelset.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_guardduty_threatintelset.this.tags_all
}

output "id" {
  description = "The ID of the GuardDuty ThreatIntelSet"
  value       = aws_guardduty_threatintelset.this.id
}