output "arn" {
  description = "Amazon Resource Name (ARN) of the Security Hub custom action target."
  value       = aws_securityhub_action_target.this.arn
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_securityhub_action_target.this.region
}

output "name" {
  description = "The description for the custom action target."
  value       = aws_securityhub_action_target.this.name
}

output "identifier" {
  description = "The ID for the custom action target."
  value       = aws_securityhub_action_target.this.identifier
}

output "description" {
  description = "The name of the custom action target."
  value       = aws_securityhub_action_target.this.description
}