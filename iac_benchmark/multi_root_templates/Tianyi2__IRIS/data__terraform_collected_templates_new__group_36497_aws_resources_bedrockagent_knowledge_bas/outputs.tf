output "arn" {
  description = "ARN of the knowledge base."
  value       = aws_bedrockagent_knowledge_base.this.arn
}

output "created_at" {
  description = "Time at which the knowledge base was created."
  value       = aws_bedrockagent_knowledge_base.this.created_at
}

output "id" {
  description = "Unique identifier of the knowledge base."
  value       = aws_bedrockagent_knowledge_base.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_bedrockagent_knowledge_base.this.tags_all
}

output "updated_at" {
  description = "Time at which the knowledge base was last updated."
  value       = aws_bedrockagent_knowledge_base.this.updated_at
}