output "arn" {
  description = "ARN of the job queue."
  value       = data.aws_batch_job_queue.this.arn
}

output "scheduling_policy_arn" {
  description = "The ARN of the fair share scheduling policy. If this attribute has a value, the job queue uses a fair share scheduling policy. If this attribute does not have a value, the job queue uses a first in, first out (FIFO) scheduling policy."
  value       = data.aws_batch_job_queue.this.scheduling_policy_arn
}

output "status" {
  description = "Current status of the job queue (for example, CREATING or VALID)."
  value       = data.aws_batch_job_queue.this.status
}

output "status_reason" {
  description = "Short, human-readable string to provide additional details about the current status of the job queue."
  value       = data.aws_batch_job_queue.this.status_reason
}

output "state" {
  description = "Describes the ability of the queue to accept new jobs (for example, ENABLED or DISABLED)."
  value       = data.aws_batch_job_queue.this.state
}

output "tags" {
  description = "Key-value map of resource tags."
  value       = data.aws_batch_job_queue.this.tags
}

output "priority" {
  description = "Priority of the job queue. Job queues with a higher priority are evaluated first when associated with the same compute environment."
  value       = data.aws_batch_job_queue.this.priority
}

output "compute_environment_order" {
  description = "The compute environments that are attached to the job queue and the order in which job placement is preferred. Compute environments are selected for job placement in ascending order."
  value       = data.aws_batch_job_queue.this.compute_environment_order
}

output "job_state_time_limit_action" {
  description = "Specifies an action that AWS Batch will take after the job has remained at the head of the queue in the specified state for longer than the specified time."
  value       = data.aws_batch_job_queue.this.job_state_time_limit_action
}