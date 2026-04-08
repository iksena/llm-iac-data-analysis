output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_batch_job_definition.this.region
}

output "arn" {
  description = "ARN of the Job Definition"
  value       = data.aws_batch_job_definition.this.arn
}

output "revision" {
  description = "The revision of the job definition"
  value       = data.aws_batch_job_definition.this.revision
}

output "name" {
  description = "The name of the job definition"
  value       = data.aws_batch_job_definition.this.name
}

output "status" {
  description = "The status of the job definition"
  value       = data.aws_batch_job_definition.this.status
}

output "container_orchestration_type" {
  description = "The orchestration type of the compute environment"
  value       = data.aws_batch_job_definition.this.container_orchestration_type
}

output "scheduling_priority" {
  description = "The scheduling priority for jobs that are submitted with this job definition"
  value       = data.aws_batch_job_definition.this.scheduling_priority
}

output "id" {
  description = "The ARN"
  value       = data.aws_batch_job_definition.this.id
}

output "eks_properties" {
  description = "Object with various properties that are specific to Amazon EKS based jobs"
  value       = data.aws_batch_job_definition.this.eks_properties
}

output "node_properties" {
  description = "Object with various properties specific to multi-node parallel jobs"
  value       = data.aws_batch_job_definition.this.node_properties
}

output "retry_strategy" {
  description = "The retry strategy to use for failed jobs that are submitted with this job definition"
  value       = data.aws_batch_job_definition.this.retry_strategy
}

output "timeout" {
  description = "The timeout configuration for jobs that are submitted with this job definition"
  value       = data.aws_batch_job_definition.this.timeout
}