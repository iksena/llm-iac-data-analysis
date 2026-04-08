output "association_arn" {
  description = "The Amazon Resource Name (ARN) of the association."
  value       = aws_eks_pod_identity_association.this.association_arn
}

output "association_id" {
  description = "The ID of the association."
  value       = aws_eks_pod_identity_association.this.association_id
}

output "external_id" {
  description = "The unique identifier for this association for a target IAM role. You put this value in the trust policy of the target role, in a Condition to match the sts.ExternalId."
  value       = aws_eks_pod_identity_association.this.external_id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_eks_pod_identity_association.this.tags_all
}