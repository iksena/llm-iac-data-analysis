output "arn" {
  description = "ARN of the profiling group"
  value       = aws_codeguruprofiler_profiling_group.this.arn
}

output "id" {
  description = "Name of the profiling group"
  value       = aws_codeguruprofiler_profiling_group.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_codeguruprofiler_profiling_group.this.tags_all
}