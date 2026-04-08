output "arn" {
  description = "ARN of the job template"
  value       = aws_emrcontainers_job_template.this.arn
}

output "id" {
  description = "The ID of the job template"
  value       = aws_emrcontainers_job_template.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_emrcontainers_job_template.this.tags_all
}