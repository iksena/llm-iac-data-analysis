

resource "aws_ssm_parameter" "cluster_name" {
  name  = "/${var.name}/cluster_name"
  type  = "String"
  value = module.eks.cluster_name
}

output "cluster_name" {
  description = "The name of the EKS cluster"
  value       = module.eks.cluster_name
}

resource "aws_ssm_parameter" "cluster_endpoint" {
  name  = "/${var.name}/cluster_endpoint"
  type  = "String"
  value = module.eks.cluster_endpoint
}

output "cluster_endpoint" {
  description = "Endpoint for your Kubernetes API server"
  value       = module.eks.cluster_endpoint
}

resource "aws_ssm_parameter" "oidc_provider_arn" {
  name  = "/${var.name}/oidc_provider_arn"
  type  = "String"
  value = module.eks.oidc_provider_arn
}

output "oidc_provider_arn" {
  description = "The ARN of the OIDC Provider if `enable_irsa = true`"
  value       = module.eks.oidc_provider_arn
}


resource "aws_ssm_parameter" "cluster_version" {
  name  = "/${var.name}/cluster_version"
  type  = "String"
  value = module.eks.cluster_version
}

output "cluster_version" {
  description = "The Kubernetes version for the cluster"
  value       = module.eks.cluster_version
}

resource "aws_ssm_parameter" "cluster_primary_security_group_id" {
  name  = "/${var.name}/cluster_primary_security_group_id"
  type  = "String"
  value = module.eks.cluster_primary_security_group_id
}

output "cluster_primary_security_group_id" {
  description = "Cluster security group that was created by Amazon EKS for the cluster. Managed node groups use this security group for control-plane-to-data-plane communication. Referred to as 'Cluster security group' in the EKS console"
  value       = module.eks.cluster_primary_security_group_id
}

resource "aws_ssm_parameter" "cluster_service_cidr" {
  name  = "/${var.name}/cluster_service_cidr"
  type  = "String"
  value = module.eks.cluster_service_cidr
}

output "cluster_service_cidr" {
  description = "The CIDR block where Kubernetes pod and service IP addresses are assigned from"
  value       = module.eks.cluster_service_cidr
}

resource "aws_ssm_parameter" "node_security_group_id" {
  name  = "/${var.name}/node_security_group_id"
  type  = "String"
  value = module.eks.node_security_group_id
}

output "node_security_group_id" {
  description = "ID of the node shared security group"
  value       = module.eks.node_security_group_id
}

resource "aws_ssm_parameter" "cluster_certificate_authority_data" {
  name  = "/${var.name}/cluster_certificate_authority_data"
  type  = "String"
  value = module.eks.cluster_certificate_authority_data
}

output "cluster_certificate_authority_data" {
  description = "Base64 encoded certificate data required to communicate with the cluster"
  value       = module.eks.cluster_certificate_authority_data
}
