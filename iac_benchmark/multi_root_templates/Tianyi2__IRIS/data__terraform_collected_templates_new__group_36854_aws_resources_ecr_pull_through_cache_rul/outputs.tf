output "registry_id" {
  description = "The registry ID where the repository was created."
  value       = aws_ecr_pull_through_cache_rule.this.registry_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ecr_pull_through_cache_rule.this.region
}

output "credential_arn" {
  description = "ARN of the Secret which will be used to authenticate against the registry."
  value       = aws_ecr_pull_through_cache_rule.this.credential_arn
}

output "custom_role_arn" {
  description = "The ARN of the IAM role associated with the pull through cache rule."
  value       = aws_ecr_pull_through_cache_rule.this.custom_role_arn
}

output "ecr_repository_prefix" {
  description = "The repository name prefix to use when caching images from the source registry."
  value       = aws_ecr_pull_through_cache_rule.this.ecr_repository_prefix
}

output "upstream_registry_url" {
  description = "The registry URL of the upstream registry to use as the source."
  value       = aws_ecr_pull_through_cache_rule.this.upstream_registry_url
}

output "upstream_repository_prefix" {
  description = "The upstream repository prefix associated with the pull through cache rule."
  value       = aws_ecr_pull_through_cache_rule.this.upstream_repository_prefix
}