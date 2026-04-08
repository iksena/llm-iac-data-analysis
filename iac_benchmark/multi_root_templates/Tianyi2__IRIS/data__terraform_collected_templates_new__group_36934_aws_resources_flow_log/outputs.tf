output "id" {
  description = "Flow Log ID"
  value       = aws_flow_log.this.id
}

output "arn" {
  description = "ARN of the Flow Log"
  value       = aws_flow_log.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_flow_log.this.tags_all
}