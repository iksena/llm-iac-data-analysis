output "associated_at" {
  description = "Date and time in RFC3339 format that the policy was associated."
  value       = aws_eks_access_policy_association.this.associated_at
}

output "modified_at" {
  description = "Date and time in RFC3339 format that the policy was updated."
  value       = aws_eks_access_policy_association.this.modified_at
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_eks_access_policy_association.this.region
}

output "cluster_name" {
  description = "Name of the EKS Cluster."
  value       = aws_eks_access_policy_association.this.cluster_name
}

output "policy_arn" {
  description = "The ARN of the access policy that is associated."
  value       = aws_eks_access_policy_association.this.policy_arn
}

output "principal_arn" {
  description = "The IAM Principal ARN which has authentication access to the EKS cluster."
  value       = aws_eks_access_policy_association.this.principal_arn
}

output "access_scope" {
  description = "The configuration block that determines the scope of the access."
  value       = aws_eks_access_policy_association.this.access_scope
}