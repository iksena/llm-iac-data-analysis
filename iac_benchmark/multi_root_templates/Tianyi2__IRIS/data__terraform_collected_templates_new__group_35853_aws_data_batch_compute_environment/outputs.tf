output "arn" {
  description = "ARN of the compute environment"
  value       = data.aws_batch_compute_environment.this.arn
}

output "ecs_cluster_arn" {
  description = "ARN of the underlying Amazon ECS cluster used by the compute environment"
  value       = data.aws_batch_compute_environment.this.ecs_cluster_arn
}

output "service_role" {
  description = "ARN of the IAM role that allows AWS Batch to make calls to other AWS services on your behalf"
  value       = data.aws_batch_compute_environment.this.service_role
}

output "type" {
  description = "Type of the compute environment (for example, MANAGED or UNMANAGED)"
  value       = data.aws_batch_compute_environment.this.type
}

output "status" {
  description = "Current status of the compute environment (for example, CREATING or VALID)"
  value       = data.aws_batch_compute_environment.this.status
}

output "status_reason" {
  description = "Short, human-readable string to provide additional details about the current status of the compute environment"
  value       = data.aws_batch_compute_environment.this.status_reason
}

output "state" {
  description = "State of the compute environment (for example, ENABLED or DISABLED)"
  value       = data.aws_batch_compute_environment.this.state
}

output "update_policy" {
  description = "Specifies the infrastructure update policy for the compute environment"
  value       = data.aws_batch_compute_environment.this.update_policy
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = data.aws_batch_compute_environment.this.tags
}

output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_batch_compute_environment.this.region
}

output "name" {
  description = "Name of the Batch Compute Environment"
  value       = data.aws_batch_compute_environment.this.name
}