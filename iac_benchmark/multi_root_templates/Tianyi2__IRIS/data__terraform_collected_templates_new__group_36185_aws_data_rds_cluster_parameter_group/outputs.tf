output "arn" {
  description = "ARN of the cluster parameter group."
  value       = data.aws_rds_cluster_parameter_group.this.arn
}

output "family" {
  description = "Family of the cluster parameter group."
  value       = data.aws_rds_cluster_parameter_group.this.family
}

output "description" {
  description = "Description of the cluster parameter group."
  value       = data.aws_rds_cluster_parameter_group.this.description
}

output "name" {
  description = "DB cluster parameter group name."
  value       = data.aws_rds_cluster_parameter_group.this.name
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_rds_cluster_parameter_group.this.region
}