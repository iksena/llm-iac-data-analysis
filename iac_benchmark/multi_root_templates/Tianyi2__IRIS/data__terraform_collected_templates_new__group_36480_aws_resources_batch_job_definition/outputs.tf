output "arn" {
  description = "ARN of the job definition, includes revision (:#)."
  value       = aws_batch_job_definition.this.arn
}

output "arn_prefix" {
  description = "ARN without the revision number."
  value       = aws_batch_job_definition.this.arn_prefix
}

output "revision" {
  description = "Revision of the job definition."
  value       = aws_batch_job_definition.this.revision
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_batch_job_definition.this.tags_all
}