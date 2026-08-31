# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

# Copyright (c) Neferdata, Corp

output "cluster_endpoint" {
  description = "Endpoint for EKS control plane"
  value       = var.create_eks_cluster ? module.eks.cluster_endpoint : "EKS cluster not created"
}

output "cluster_security_group_id" {
  description = "Security group ids attached to the cluster control plane"
  value       = var.create_eks_cluster ? module.eks[0].cluster_security_group_id : "EKS cluster not created"
}

output "region" {
  description = "AWS region"
  value       = var.region
}

output "cluster_name" {
  description = "Kubernetes Cluster Name"
  value       = var.create_eks_cluster ? module.eks.cluster_name : "EKS cluster not created"
}

output "postgres_endpoint" {
  description = "Endpoint for the PostgreSQL instance"
  value       = var.create_rds_instance ? aws_db_instance.postgres[0].endpoint : "RDS instance not created"
}

output "postgres_port" {
  description = "DB port"
  value       = var.create_rds_instance ? aws_db_instance.postgres[0].port : "RDS instance not created"
}

output "current_account_id" {
  description = "The current AWS account ID"
  value       = data.aws_caller_identity.current.account_id
}