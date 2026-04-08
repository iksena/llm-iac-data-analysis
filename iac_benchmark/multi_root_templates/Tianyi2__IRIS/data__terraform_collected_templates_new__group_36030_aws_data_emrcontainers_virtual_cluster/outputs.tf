output "id" {
  description = "ID of the cluster"
  value       = data.aws_emrcontainers_virtual_cluster.this.id
}

output "name" {
  description = "Name of the cluster"
  value       = data.aws_emrcontainers_virtual_cluster.this.name
}

output "arn" {
  description = "ARN of the cluster"
  value       = data.aws_emrcontainers_virtual_cluster.this.arn
}

output "container_provider" {
  description = "Nested attribute containing information about the underlying container provider (EKS cluster) for your EMR Containers cluster"
  value       = data.aws_emrcontainers_virtual_cluster.this.container_provider
}

output "container_provider_id" {
  description = "The name of the container provider that is running your EMR Containers cluster"
  value       = try(data.aws_emrcontainers_virtual_cluster.this.container_provider[0].id, null)
}

output "container_provider_info" {
  description = "Nested list containing information about the configuration of the container provider"
  value       = try(data.aws_emrcontainers_virtual_cluster.this.container_provider[0].info, null)
}

output "container_provider_eks_info" {
  description = "Nested list containing EKS-specific information about the cluster where the EMR Containers cluster is running"
  value       = try(data.aws_emrcontainers_virtual_cluster.this.container_provider[0].info[0].eks_info, null)
}

output "container_provider_eks_namespace" {
  description = "The namespace where the EMR Containers cluster is running"
  value       = try(data.aws_emrcontainers_virtual_cluster.this.container_provider[0].info[0].eks_info[0].namespace, null)
}

output "container_provider_type" {
  description = "The type of the container provider"
  value       = try(data.aws_emrcontainers_virtual_cluster.this.container_provider[0].type, null)
}

output "created_at" {
  description = "Unix epoch time stamp in seconds for when the cluster was created"
  value       = data.aws_emrcontainers_virtual_cluster.this.created_at
}

output "state" {
  description = "Status of the EKS cluster. One of RUNNING, TERMINATING, TERMINATED, ARRESTED"
  value       = data.aws_emrcontainers_virtual_cluster.this.state
}

output "tags" {
  description = "Key-value mapping of resource tags"
  value       = data.aws_emrcontainers_virtual_cluster.this.tags
}