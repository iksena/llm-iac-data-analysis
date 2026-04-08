output "id" {
  description = "The ID of the policy."
  value       = aws_load_balancer_listener_policy.this.id
}

output "load_balancer_name" {
  description = "The load balancer on which the policy is defined."
  value       = aws_load_balancer_listener_policy.this.load_balancer_name
}

output "load_balancer_port" {
  description = "The load balancer listener port the policies are applied to."
  value       = aws_load_balancer_listener_policy.this.load_balancer_port
}