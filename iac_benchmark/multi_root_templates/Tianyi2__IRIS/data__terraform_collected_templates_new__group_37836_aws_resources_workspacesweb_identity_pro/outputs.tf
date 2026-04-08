output "identity_provider_arn" {
  description = "ARN of the identity provider."
  value       = aws_workspacesweb_identity_provider.this.identity_provider_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_workspacesweb_identity_provider.this.tags_all
}