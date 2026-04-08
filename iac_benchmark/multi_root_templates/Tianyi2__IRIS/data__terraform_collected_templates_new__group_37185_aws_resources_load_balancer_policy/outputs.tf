output "id" {
  description = "The ID of the policy."
  value       = aws_load_balancer_policy.this.id
}

output "policy_name" {
  description = "The name of the stickiness policy."
  value       = aws_load_balancer_policy.this.policy_name
}

output "policy_type_name" {
  description = "The policy type of the policy."
  value       = aws_load_balancer_policy.this.policy_type_name
}

output "load_balancer_name" {
  description = "The load balancer on which the policy is defined."
  value       = aws_load_balancer_policy.this.load_balancer_name
}