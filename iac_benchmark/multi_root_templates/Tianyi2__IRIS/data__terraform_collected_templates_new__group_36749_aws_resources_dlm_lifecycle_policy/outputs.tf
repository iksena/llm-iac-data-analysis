output "arn" {
  description = "Amazon Resource Name (ARN) of the DLM Lifecycle Policy."
  value       = aws_dlm_lifecycle_policy.this.arn
}

output "id" {
  description = "Identifier of the DLM Lifecycle Policy."
  value       = aws_dlm_lifecycle_policy.this.id
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_dlm_lifecycle_policy.this.tags_all
}