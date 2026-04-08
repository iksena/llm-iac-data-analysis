output "id" {
  description = "The ID of the policy"
  value       = aws_lb_cookie_stickiness_policy.this.id
}

output "name" {
  description = "The name of the stickiness policy"
  value       = aws_lb_cookie_stickiness_policy.this.name
}

output "load_balancer" {
  description = "The load balancer to which the policy is attached"
  value       = aws_lb_cookie_stickiness_policy.this.load_balancer
}

output "lb_port" {
  description = "The load balancer port to which the policy is applied"
  value       = aws_lb_cookie_stickiness_policy.this.lb_port
}

output "cookie_expiration_period" {
  description = "The time period after which the session cookie is considered stale, expressed in seconds"
  value       = aws_lb_cookie_stickiness_policy.this.cookie_expiration_period
}