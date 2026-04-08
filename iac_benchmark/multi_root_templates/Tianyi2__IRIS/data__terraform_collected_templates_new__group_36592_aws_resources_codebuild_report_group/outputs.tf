output "id" {
  description = "The ARN of Report Group."
  value       = aws_codebuild_report_group.this.id
}

output "arn" {
  description = "The ARN of Report Group."
  value       = aws_codebuild_report_group.this.arn
}

output "created" {
  description = "The date and time this Report Group was created."
  value       = aws_codebuild_report_group.this.created
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_codebuild_report_group.this.tags_all
}