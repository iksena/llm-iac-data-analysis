output "registry_id" {
  description = "The registry ID where the repository was created."
  value       = aws_ecrpublic_repository_policy.this.registry_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ecrpublic_repository_policy.this.region
}

output "repository_name" {
  description = "Name of the repository to which the policy is applied."
  value       = aws_ecrpublic_repository_policy.this.repository_name
}

output "policy" {
  description = "The policy document applied to the repository."
  value       = aws_ecrpublic_repository_policy.this.policy
}