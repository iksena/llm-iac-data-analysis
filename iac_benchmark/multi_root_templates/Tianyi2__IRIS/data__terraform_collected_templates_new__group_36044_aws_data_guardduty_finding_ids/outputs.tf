output "has_findings" {
  description = "Indicates whether findings are present for the specified detector."
  value       = data.aws_guardduty_finding_ids.this.has_findings
}

output "finding_ids" {
  description = "A list of finding IDs for the specified detector."
  value       = data.aws_guardduty_finding_ids.this.finding_ids
}