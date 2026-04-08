output "policy" {
  description = "JSON-encoded string representation of the applied resource policy."
  value       = data.aws_vpclattice_resource_policy.this.policy
}

output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_vpclattice_resource_policy.this.region
}

output "resource_arn" {
  description = "Resource ARN of the resource for which a policy is retrieved."
  value       = data.aws_vpclattice_resource_policy.this.resource_arn
}