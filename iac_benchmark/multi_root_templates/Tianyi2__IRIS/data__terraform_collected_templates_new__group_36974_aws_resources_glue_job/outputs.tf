output "arn" {
  description = "Amazon Resource Name (ARN) of Glue Job"
  value       = aws_glue_job.this.arn
}

output "id" {
  description = "Job name"
  value       = aws_glue_job.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_glue_job.this.tags_all
}