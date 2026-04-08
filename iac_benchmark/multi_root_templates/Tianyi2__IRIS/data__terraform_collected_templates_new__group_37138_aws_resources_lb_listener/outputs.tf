output "arn" {
  description = "ARN of the listener"
  value       = aws_lb_listener.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_lb_listener.this.tags_all
}