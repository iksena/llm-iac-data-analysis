output "id" {
  description = "The name of the topic rule"
  value       = aws_iot_topic_rule.this.id
}

output "arn" {
  description = "The ARN of the topic rule"
  value       = aws_iot_topic_rule.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_iot_topic_rule.this.tags_all
}