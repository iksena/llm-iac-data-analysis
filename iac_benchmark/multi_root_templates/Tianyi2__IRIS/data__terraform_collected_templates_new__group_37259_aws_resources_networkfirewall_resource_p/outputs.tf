output "id" {
  description = "The Amazon Resource Name (ARN) of the rule group or firewall policy associated with the resource policy."
  value       = aws_networkfirewall_resource_policy.this.id
}