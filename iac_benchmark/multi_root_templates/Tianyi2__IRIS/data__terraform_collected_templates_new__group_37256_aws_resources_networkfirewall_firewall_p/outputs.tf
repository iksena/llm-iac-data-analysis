output "id" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy."
  value       = aws_networkfirewall_firewall_policy.this.id
}

output "arn" {
  description = "The Amazon Resource Name (ARN) that identifies the firewall policy."
  value       = aws_networkfirewall_firewall_policy.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_networkfirewall_firewall_policy.this.tags_all
}

output "update_token" {
  description = "A string token used when updating a firewall policy."
  value       = aws_networkfirewall_firewall_policy.this.update_token
}