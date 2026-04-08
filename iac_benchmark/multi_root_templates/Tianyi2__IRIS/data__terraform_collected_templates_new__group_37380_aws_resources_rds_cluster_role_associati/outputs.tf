output "id" {
  description = "DB Cluster Identifier and IAM Role ARN separated by a comma (,)"
  value       = aws_rds_cluster_role_association.this.id
}