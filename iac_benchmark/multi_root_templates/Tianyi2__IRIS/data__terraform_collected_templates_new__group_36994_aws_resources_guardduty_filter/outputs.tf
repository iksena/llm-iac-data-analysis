output "arn" {
  description = "The ARN of the GuardDuty filter."
  value       = aws_guardduty_filter.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_guardduty_filter.this.tags_all
}

output "id" {
  description = "The ID of the GuardDuty filter."
  value       = aws_guardduty_filter.this.id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_guardduty_filter.this.region
}

output "detector_id" {
  description = "ID of the GuardDuty detector."
  value       = aws_guardduty_filter.this.detector_id
}

output "name" {
  description = "The name of the filter."
  value       = aws_guardduty_filter.this.name
}

output "description" {
  description = "Description of the filter."
  value       = aws_guardduty_filter.this.description
}

output "rank" {
  description = "The position of the filter in the list of current filters."
  value       = aws_guardduty_filter.this.rank
}

output "action" {
  description = "The action that is applied to the findings that match the filter."
  value       = aws_guardduty_filter.this.action
}

output "tags" {
  description = "The tags assigned to the Filter resource."
  value       = aws_guardduty_filter.this.tags
}

output "finding_criteria" {
  description = "The criteria used in the filter for querying findings."
  value       = aws_guardduty_filter.this.finding_criteria
}