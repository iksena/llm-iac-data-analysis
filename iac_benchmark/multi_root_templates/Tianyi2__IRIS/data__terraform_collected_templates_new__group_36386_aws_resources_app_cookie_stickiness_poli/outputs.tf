output "id" {
  description = "ID of the policy."
  value       = aws_app_cookie_stickiness_policy.this.id
}

output "name" {
  description = "Name of the stickiness policy."
  value       = aws_app_cookie_stickiness_policy.this.name
}

output "load_balancer" {
  description = "Name of load balancer to which the policy is attached."
  value       = aws_app_cookie_stickiness_policy.this.load_balancer
}

output "lb_port" {
  description = "Load balancer port to which the policy is applied."
  value       = aws_app_cookie_stickiness_policy.this.lb_port
}

output "cookie_name" {
  description = "Application cookie whose lifetime the ELB's cookie should follow."
  value       = aws_app_cookie_stickiness_policy.this.cookie_name
}