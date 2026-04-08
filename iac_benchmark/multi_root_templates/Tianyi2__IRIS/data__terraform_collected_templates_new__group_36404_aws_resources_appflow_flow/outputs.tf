output "arn" {
  description = "Flow's ARN"
  value       = aws_appflow_flow.this.arn
}

output "flow_status" {
  description = "The current status of the flow"
  value       = aws_appflow_flow.this.flow_status
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_appflow_flow.this.tags_all
}