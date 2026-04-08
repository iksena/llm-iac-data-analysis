output "arn" {
  description = "ARN of the routing control."
  value       = aws_route53recoverycontrolconfig_routing_control.this.arn
}

output "status" {
  description = "Status of routing control. PENDING when it is being created/updated, PENDING_DELETION when it is being deleted, and DEPLOYED otherwise."
  value       = aws_route53recoverycontrolconfig_routing_control.this.status
}