output "id" {
  description = "Name of the cluster"
  value       = data.aws_eks_cluster.this.id
}

output "arn" {
  description = "ARN of the cluster"
  value       = data.aws_eks_cluster.this.arn
}

output "access_config" {
  description = "Configuration block for access config"
  value       = data.aws_eks_cluster.this.access_config
}

output "compute_config" {
  description = "Nested attribute containing compute capability configuration for EKS Auto Mode enabled cluster"
  value       = data.aws_eks_cluster.this.compute_config
}

output "certificate_authority" {
  description = "Nested attribute containing certificate-authority-data for your cluster"
  value       = data.aws_eks_cluster.this.certificate_authority
}

output "cluster_id" {
  description = "The ID of your local Amazon EKS cluster on the AWS Outpost. This attribute isn't available for an AWS EKS cluster on AWS cloud"
  value       = data.aws_eks_cluster.this.cluster_id
}

output "created_at" {
  description = "Unix epoch time stamp in seconds for when the cluster was created"
  value       = data.aws_eks_cluster.this.created_at
}

output "deletion_protection" {
  description = "Whether deletion protection for the cluster is enabled"
  value       = data.aws_eks_cluster.this.deletion_protection
}

output "enabled_cluster_log_types" {
  description = "The enabled control plane logs"
  value       = data.aws_eks_cluster.this.enabled_cluster_log_types
}

output "endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = data.aws_eks_cluster.this.endpoint
}

output "identity" {
  description = "Nested attribute containing identity provider information for your cluster"
  value       = data.aws_eks_cluster.this.identity
}

output "kubernetes_network_config" {
  description = "Nested list containing Kubernetes Network Configuration"
  value       = data.aws_eks_cluster.this.kubernetes_network_config
}

output "outpost_config" {
  description = "Contains Outpost Configuration"
  value       = data.aws_eks_cluster.this.outpost_config
}

output "platform_version" {
  description = "Platform version for the cluster"
  value       = data.aws_eks_cluster.this.platform_version
}

output "remote_network_config" {
  description = "Contains remote network configuration for EKS Hybrid Nodes"
  value       = data.aws_eks_cluster.this.remote_network_config
}

output "role_arn" {
  description = "ARN of the IAM role that provides permissions for the Kubernetes control plane to make calls to AWS API operations on your behalf"
  value       = data.aws_eks_cluster.this.role_arn
}

output "status" {
  description = "Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED"
  value       = data.aws_eks_cluster.this.status
}

output "storage_config" {
  description = "Contains storage configuration for EKS Auto Mode enabled cluster"
  value       = data.aws_eks_cluster.this.storage_config
}

output "tags" {
  description = "Key-value map of resource tags"
  value       = data.aws_eks_cluster.this.tags
}

output "upgrade_policy" {
  description = "Configuration block for the support policy to use for the cluster"
  value       = data.aws_eks_cluster.this.upgrade_policy
}

output "version" {
  description = "Kubernetes server version for the cluster"
  value       = data.aws_eks_cluster.this.version
}

output "vpc_config" {
  description = "Nested list containing VPC configuration for the cluster"
  value       = data.aws_eks_cluster.this.vpc_config
}

output "zonal_shift_config" {
  description = "Contains Zonal Shift Configuration"
  value       = data.aws_eks_cluster.this.zonal_shift_config
}