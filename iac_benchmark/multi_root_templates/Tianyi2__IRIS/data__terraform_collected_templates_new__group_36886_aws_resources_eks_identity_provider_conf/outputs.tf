output "arn" {
  description = "Amazon Resource Name (ARN) of the EKS Identity Provider Configuration"
  value       = aws_eks_identity_provider_config.this.arn
}

output "id" {
  description = "EKS Cluster name and EKS Identity Provider Configuration name separated by a colon (:)"
  value       = aws_eks_identity_provider_config.this.id
}

output "status" {
  description = "Status of the EKS Identity Provider Configuration"
  value       = aws_eks_identity_provider_config.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_eks_identity_provider_config.this.tags_all
}