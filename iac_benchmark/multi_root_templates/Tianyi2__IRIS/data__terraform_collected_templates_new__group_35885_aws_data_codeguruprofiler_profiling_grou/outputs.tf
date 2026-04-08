output "agent_orchestration_config" {
  description = "Profiling Group agent orchestration config"
  value       = data.aws_codeguruprofiler_profiling_group.this.agent_orchestration_config
}

output "arn" {
  description = "ARN of the Profiling Group."
  value       = data.aws_codeguruprofiler_profiling_group.this.arn
}

output "created_at" {
  description = "Timestamp when Profiling Group was created."
  value       = data.aws_codeguruprofiler_profiling_group.this.created_at
}

output "compute_platform" {
  description = "The compute platform of the profiling group."
  value       = data.aws_codeguruprofiler_profiling_group.this.compute_platform
}

output "profiling_status" {
  description = "The status of the Profiling Group."
  value       = data.aws_codeguruprofiler_profiling_group.this.profiling_status
}

output "tags" {
  description = "Mapping of Key-Value tags for the resource."
  value       = data.aws_codeguruprofiler_profiling_group.this.tags
}

output "updated_at" {
  description = "Timestamp when Profiling Group was updated."
  value       = data.aws_codeguruprofiler_profiling_group.this.updated_at
}