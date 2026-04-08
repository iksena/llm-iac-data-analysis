output "arn" {
  description = "The ARN of the scalable target."
  value       = aws_appautoscaling_target.this.arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_appautoscaling_target.this.tags_all
}