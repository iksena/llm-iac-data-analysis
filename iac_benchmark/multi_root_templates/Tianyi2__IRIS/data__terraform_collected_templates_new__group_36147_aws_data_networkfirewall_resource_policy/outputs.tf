output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the resource policy."
  value       = data.aws_networkfirewall_resource_policy.this.id
}

output "policy" {
  description = "The policy for the resource."
  value       = data.aws_networkfirewall_resource_policy.this.policy
}

output "region" {
  description = "Region where this resource is managed."
  value       = data.aws_networkfirewall_resource_policy.this.region
}

output "resource_arn" {
  description = "The Amazon Resource Name (ARN) that identifies the resource policy."
  value       = data.aws_networkfirewall_resource_policy.this.resource_arn
}