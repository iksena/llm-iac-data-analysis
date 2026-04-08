output "id" {
  description = "The unique identifier (ID) of the macie Findings Filter."
  value       = aws_macie2_findings_filter.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) of the Findings Filter."
  value       = aws_macie2_findings_filter.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_macie2_findings_filter.this.tags_all
}