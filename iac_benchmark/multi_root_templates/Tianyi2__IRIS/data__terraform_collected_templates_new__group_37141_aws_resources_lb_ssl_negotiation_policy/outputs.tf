output "id" {
  description = "The ID of the policy."
  value       = aws_lb_ssl_negotiation_policy.this.id
}

output "name" {
  description = "The name of the stickiness policy."
  value       = aws_lb_ssl_negotiation_policy.this.name
}

output "load_balancer" {
  description = "The load balancer to which the policy is attached."
  value       = aws_lb_ssl_negotiation_policy.this.load_balancer
}

output "lb_port" {
  description = "The load balancer port to which the policy is applied."
  value       = aws_lb_ssl_negotiation_policy.this.lb_port
}

output "attribute" {
  description = "The SSL Negotiation policy attributes."
  value       = aws_lb_ssl_negotiation_policy.this.attribute
}