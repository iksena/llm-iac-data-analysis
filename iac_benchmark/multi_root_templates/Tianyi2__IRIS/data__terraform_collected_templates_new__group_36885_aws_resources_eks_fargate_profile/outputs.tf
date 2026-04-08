output "arn" {
  description = "Amazon Resource Name (ARN) of the EKS Fargate Profile"
  value       = aws_eks_fargate_profile.this.arn
}

output "id" {
  description = "EKS Cluster name and EKS Fargate Profile name separated by a colon (:)"
  value       = aws_eks_fargate_profile.this.id
}

output "status" {
  description = "Status of the EKS Fargate Profile"
  value       = aws_eks_fargate_profile.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_eks_fargate_profile.this.tags_all
}