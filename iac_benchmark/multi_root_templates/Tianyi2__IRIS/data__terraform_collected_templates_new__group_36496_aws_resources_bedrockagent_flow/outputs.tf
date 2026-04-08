output "arn" {
  description = "The Amazon Resource Name (ARN) of the flow."
  value       = aws_bedrockagent_flow.this.arn
}

output "id" {
  description = "The unique identifier of the flow."
  value       = aws_bedrockagent_flow.this.id
}

output "created_at" {
  description = "The time at which the flow was created."
  value       = aws_bedrockagent_flow.this.created_at
}

output "updated_at" {
  description = "The time at which the flow was last updated."
  value       = aws_bedrockagent_flow.this.updated_at
}

output "version" {
  description = "The version of the flow."
  value       = aws_bedrockagent_flow.this.version
}

output "status" {
  description = "The status of the flow."
  value       = aws_bedrockagent_flow.this.status
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_bedrockagent_flow.this.tags_all
}