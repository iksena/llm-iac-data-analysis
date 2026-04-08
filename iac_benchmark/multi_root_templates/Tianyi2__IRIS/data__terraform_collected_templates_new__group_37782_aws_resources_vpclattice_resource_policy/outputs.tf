output "region" {
  description = "Region where this resource is managed."
  value       = aws_vpclattice_resource_policy.this.region
}

output "resource_arn" {
  description = "The ID or Amazon Resource Name (ARN) of the service network or service for which the policy is created."
  value       = aws_vpclattice_resource_policy.this.resource_arn
}

output "policy" {
  description = "The IAM policy attached to the resource."
  value       = aws_vpclattice_resource_policy.this.policy
}