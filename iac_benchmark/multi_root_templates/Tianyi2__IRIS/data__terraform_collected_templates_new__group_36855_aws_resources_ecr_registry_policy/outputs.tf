output "registry_id" {
  description = "The registry ID where the registry was created."
  value       = aws_ecr_registry_policy.this.registry_id
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_ecr_registry_policy.this.region
}

output "policy" {
  description = "The policy document."
  value       = aws_ecr_registry_policy.this.policy
}