output "arn" {
  description = "ARN of the control panel."
  value       = aws_route53recoverycontrolconfig_control_panel.this.arn
}

output "default_control_panel" {
  description = "Whether a control panel is default."
  value       = aws_route53recoverycontrolconfig_control_panel.this.default_control_panel
}

output "routing_control_count" {
  description = "Number routing controls in a control panel."
  value       = aws_route53recoverycontrolconfig_control_panel.this.routing_control_count
}

output "status" {
  description = "Status of control panel: PENDING when it is being created/updated, PENDING_DELETION when it is being deleted, and DEPLOYED otherwise."
  value       = aws_route53recoverycontrolconfig_control_panel.this.status
}