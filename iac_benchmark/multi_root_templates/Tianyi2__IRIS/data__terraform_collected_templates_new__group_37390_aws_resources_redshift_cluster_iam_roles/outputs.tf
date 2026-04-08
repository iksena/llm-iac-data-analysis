output "id" {
  description = "The Redshift Cluster ID."
  value       = aws_redshift_cluster_iam_roles.this.id
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_redshift_cluster_iam_roles.this.region
}

output "cluster_identifier" {
  description = "The name of the Redshift Cluster IAM Roles."
  value       = aws_redshift_cluster_iam_roles.this.cluster_identifier
}

output "iam_role_arns" {
  description = "A list of IAM Role ARNs to associate with the cluster."
  value       = aws_redshift_cluster_iam_roles.this.iam_role_arns
}

output "default_iam_role_arn" {
  description = "The Amazon Resource Name (ARN) for the IAM role that was set as default for the cluster."
  value       = aws_redshift_cluster_iam_roles.this.default_iam_role_arn
}