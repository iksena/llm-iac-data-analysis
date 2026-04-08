output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_lb_listener_rule.this.region
}

output "arn" {
  description = "ARN of the Listener Rule"
  value       = data.aws_lb_listener_rule.this.arn
}

output "listener_arn" {
  description = "ARN of the associated Listener"
  value       = data.aws_lb_listener_rule.this.listener_arn
}

output "priority" {
  description = "Priority of the Listener Rule within the Listener"
  value       = data.aws_lb_listener_rule.this.priority
}

output "action" {
  description = "List of actions associated with the rule, sorted by order"
  value       = data.aws_lb_listener_rule.this.action
}

output "condition" {
  description = "Set of conditions associated with the rule"
  value       = data.aws_lb_listener_rule.this.condition
}

output "tags" {
  description = "Tags assigned to the Listener Rule"
  value       = data.aws_lb_listener_rule.this.tags
}