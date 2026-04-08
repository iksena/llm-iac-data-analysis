output "id" {
  description = "The name of the sampling rule"
  value       = aws_xray_sampling_rule.this.id
}

output "arn" {
  description = "The ARN of the sampling rule"
  value       = aws_xray_sampling_rule.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_xray_sampling_rule.this.tags_all
}