output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_networkfirewall_firewall_policy.this.region
}

output "arn" {
  description = "ARN of the firewall policy"
  value       = data.aws_networkfirewall_firewall_policy.this.arn
}

output "name" {
  description = "Descriptive name of the firewall policy"
  value       = data.aws_networkfirewall_firewall_policy.this.name
}

output "description" {
  description = "Description of the firewall policy"
  value       = data.aws_networkfirewall_firewall_policy.this.description
}

output "firewall_policy" {
  description = "The policy for the specified firewall policy"
  value       = data.aws_networkfirewall_firewall_policy.this.firewall_policy
}

output "tags" {
  description = "Key-value tags for the firewall policy"
  value       = data.aws_networkfirewall_firewall_policy.this.tags
}

output "update_token" {
  description = "Token used for optimistic locking"
  value       = data.aws_networkfirewall_firewall_policy.this.update_token
}