output "arn" {
  description = "ARN of the Replicator."
  value       = aws_msk_replicator.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_msk_replicator.this.tags_all
}

output "id" {
  description = "The ID of the MSK Replicator."
  value       = aws_msk_replicator.this.id
}

output "replicator_name" {
  description = "The name of the replicator."
  value       = aws_msk_replicator.this.replicator_name
}

output "description" {
  description = "A summary description of the replicator."
  value       = aws_msk_replicator.this.description
}

output "service_execution_role_arn" {
  description = "The ARN of the IAM role used by the replicator to access resources in the customer's account."
  value       = aws_msk_replicator.this.service_execution_role_arn
}

output "kafka_cluster" {
  description = "A list of Kafka clusters which are targets of the replicator."
  value       = aws_msk_replicator.this.kafka_cluster
}

output "replication_info_list" {
  description = "A list of replication configurations, where each configuration targets a given source cluster to target cluster replication flow."
  value       = aws_msk_replicator.this.replication_info_list
}