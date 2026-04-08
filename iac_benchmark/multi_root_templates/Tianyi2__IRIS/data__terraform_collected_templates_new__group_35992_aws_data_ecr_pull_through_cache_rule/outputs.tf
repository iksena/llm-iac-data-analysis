output "id" {
  description = "The repository name prefix."
  value       = data.aws_ecr_pull_through_cache_rule.this.id
}

output "credential_arn" {
  description = "ARN of the Secret which will be used to authenticate against the registry."
  value       = data.aws_ecr_pull_through_cache_rule.this.credential_arn
}

output "custom_role_arn" {
  description = "The ARN of the IAM role associated with the pull through cache rule. Used if the upstream registry is a cross-account ECR private registry."
  value       = data.aws_ecr_pull_through_cache_rule.this.custom_role_arn
}

output "registry_id" {
  description = "The registry ID where the repository was created."
  value       = data.aws_ecr_pull_through_cache_rule.this.registry_id
}

output "upstream_registry_url" {
  description = "The registry URL of the upstream registry to use as the source."
  value       = data.aws_ecr_pull_through_cache_rule.this.upstream_registry_url
}

output "upstream_repository_prefix" {
  description = "The upstream repository prefix associated with the pull through cache rule."
  value       = data.aws_ecr_pull_through_cache_rule.this.upstream_repository_prefix
}