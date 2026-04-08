output "arn" {
  description = "The ARN of the serverless cluster."
  value       = aws_msk_serverless_cluster.this.arn
}

output "bootstrap_brokers_sasl_iam" {
  description = "One or more DNS names (or IP addresses) and SASL IAM port pairs."
  value       = aws_msk_serverless_cluster.this.bootstrap_brokers_sasl_iam
}

output "cluster_uuid" {
  description = "UUID of the serverless cluster, for use in IAM policies."
  value       = aws_msk_serverless_cluster.this.cluster_uuid
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_msk_serverless_cluster.this.tags_all
}