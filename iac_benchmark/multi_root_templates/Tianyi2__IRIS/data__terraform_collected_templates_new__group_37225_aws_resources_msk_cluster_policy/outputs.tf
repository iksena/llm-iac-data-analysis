output "id" {
  description = "Same as cluster_arn."
  value       = aws_msk_cluster_policy.this.id
}

output "cluster_arn" {
  description = "The Amazon Resource Name (ARN) that uniquely identifies the cluster."
  value       = aws_msk_cluster_policy.this.cluster_arn
}

output "policy" {
  description = "Resource policy for cluster."
  value       = aws_msk_cluster_policy.this.policy
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_msk_cluster_policy.this.region
}