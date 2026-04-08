output "arn" {
  description = "The Amazon Resource Name (ARN) specifying the cur report."
  value       = aws_cur_report_definition.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_cur_report_definition.this.tags_all
}