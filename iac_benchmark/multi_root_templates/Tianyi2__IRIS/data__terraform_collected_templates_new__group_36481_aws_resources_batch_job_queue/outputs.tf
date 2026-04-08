output "arn" {
  description = "The Amazon Resource Name of the job queue."
  value       = aws_batch_job_queue.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_batch_job_queue.this.tags_all
}