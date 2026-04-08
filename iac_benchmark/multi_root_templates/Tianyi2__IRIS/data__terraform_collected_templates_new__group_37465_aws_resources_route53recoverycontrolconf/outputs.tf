output "arn" {
  description = "ARN of the safety rule"
  value       = aws_route53recoverycontrolconfig_safety_rule.this.arn
}

output "status" {
  description = "Status of the safety rule. PENDING when it is being created/updated, PENDING_DELETION when it is being deleted, and DEPLOYED otherwise"
  value       = aws_route53recoverycontrolconfig_safety_rule.this.status
}

output "id" {
  description = "The ID of the safety rule"
  value       = aws_route53recoverycontrolconfig_safety_rule.this.id
}