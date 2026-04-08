output "arn_suffix" {
  description = "ARN suffix for use with CloudWatch Metrics."
  value       = aws_lb_trust_store.this.arn_suffix
}

output "arn" {
  description = "ARN of the Trust Store (matches id)."
  value       = aws_lb_trust_store.this.arn
}

output "id" {
  description = "ARN of the Trust Store (matches arn)."
  value       = aws_lb_trust_store.this.id
}

output "name" {
  description = "Name of the Trust Store."
  value       = aws_lb_trust_store.this.name
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_lb_trust_store.this.tags_all
}