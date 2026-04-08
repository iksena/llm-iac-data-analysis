output "id" {
  description = "The ID of the policy."
  value       = aws_proxy_protocol_policy.this.id
}

output "load_balancer" {
  description = "The load balancer to which the policy is attached."
  value       = aws_proxy_protocol_policy.this.load_balancer
}