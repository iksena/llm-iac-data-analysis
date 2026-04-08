output "arn" {
  description = "ARN of the cluster."
  value       = aws_eks_cluster.this.arn
}

output "certificate_authority" {
  description = "Attribute block containing certificate-authority-data for your cluster."
  value       = aws_eks_cluster.this.certificate_authority
}

output "cluster_id" {
  description = "The ID of your local Amazon EKS cluster on the AWS Outpost. This attribute isn't available for an AWS EKS cluster on AWS cloud."
  value       = aws_eks_cluster.this.cluster_id
}

output "created_at" {
  description = "Unix epoch timestamp in seconds for when the cluster was created."
  value       = aws_eks_cluster.this.created_at
}

output "endpoint" {
  description = "Endpoint for your Kubernetes API server."
  value       = aws_eks_cluster.this.endpoint
}

output "id" {
  description = "Name of the cluster."
  value       = aws_eks_cluster.this.id
}

output "identity" {
  description = "Attribute block containing identity provider information for your cluster. Only available on Kubernetes version 1.13 and 1.14 clusters created or upgraded on or after September 3, 2019."
  value       = aws_eks_cluster.this.identity
}

output "platform_version" {
  description = "Platform version for the cluster."
  value       = aws_eks_cluster.this.platform_version
}

output "status" {
  description = "Status of the EKS cluster. One of CREATING, ACTIVE, DELETING, FAILED."
  value       = aws_eks_cluster.this.status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_eks_cluster.this.tags_all
}

output "vpc_config" {
  description = "VPC configuration for the cluster including computed values."
  value = {
    cluster_security_group_id = aws_eks_cluster.this.vpc_config[0].cluster_security_group_id
    endpoint_private_access   = aws_eks_cluster.this.vpc_config[0].endpoint_private_access
    endpoint_public_access    = aws_eks_cluster.this.vpc_config[0].endpoint_public_access
    public_access_cidrs       = aws_eks_cluster.this.vpc_config[0].public_access_cidrs
    security_group_ids        = aws_eks_cluster.this.vpc_config[0].security_group_ids
    subnet_ids                = aws_eks_cluster.this.vpc_config[0].subnet_ids
    vpc_id                    = aws_eks_cluster.this.vpc_config[0].vpc_id
  }
}

output "kubernetes_network_config" {
  description = "Kubernetes network configuration including computed values."
  value = length(aws_eks_cluster.this.kubernetes_network_config) > 0 ? {
    elastic_load_balancing = length(aws_eks_cluster.this.kubernetes_network_config[0].elastic_load_balancing) > 0 ? {
      enabled = aws_eks_cluster.this.kubernetes_network_config[0].elastic_load_balancing[0].enabled
    } : null
    service_ipv4_cidr = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv4_cidr
    service_ipv6_cidr = aws_eks_cluster.this.kubernetes_network_config[0].service_ipv6_cidr
    ip_family         = aws_eks_cluster.this.kubernetes_network_config[0].ip_family
  } : null
}