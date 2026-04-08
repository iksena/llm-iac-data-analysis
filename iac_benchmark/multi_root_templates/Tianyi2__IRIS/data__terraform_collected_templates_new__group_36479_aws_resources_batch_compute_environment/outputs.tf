output "arn" {
  description = "The Amazon Resource Name (ARN) of the compute environment."
  value       = aws_batch_compute_environment.this.arn
}

output "ecs_cluster_arn" {
  description = "The Amazon Resource Name (ARN) of the underlying Amazon ECS cluster used by the compute environment."
  value       = aws_batch_compute_environment.this.ecs_cluster_arn
}

output "status" {
  description = "The current status of the compute environment (for example, CREATING or VALID)."
  value       = aws_batch_compute_environment.this.status
}

output "status_reason" {
  description = "A short, human-readable string to provide additional details about the current status of the compute environment."
  value       = aws_batch_compute_environment.this.status_reason
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_batch_compute_environment.this.tags_all
}