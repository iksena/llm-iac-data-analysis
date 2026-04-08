output "id" {
  description = "Name used for this load balancer (matches lb_name)."
  value       = aws_lightsail_lb_https_redirection_policy.this.id
}