output "arn" {
  description = "Global Cluster ARN"
  value       = aws_neptune_global_cluster.this.arn
}

output "global_cluster_members" {
  description = "Set of objects containing Global Cluster members"
  value       = aws_neptune_global_cluster.this.global_cluster_members
}

output "global_cluster_resource_id" {
  description = "AWS Region-unique, immutable identifier for the global database cluster. This identifier is found in AWS CloudTrail log entries whenever the AWS KMS key for the DB cluster is accessed"
  value       = aws_neptune_global_cluster.this.global_cluster_resource_id
}

output "id" {
  description = "Neptune Global Cluster"
  value       = aws_neptune_global_cluster.this.id
}