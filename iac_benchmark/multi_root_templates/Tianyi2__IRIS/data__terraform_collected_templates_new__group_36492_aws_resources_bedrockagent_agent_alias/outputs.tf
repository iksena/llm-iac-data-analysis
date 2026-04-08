output "agent_alias_arn" {
  description = "ARN of the alias"
  value       = aws_bedrockagent_agent_alias.this.agent_alias_arn
}

output "agent_alias_id" {
  description = "Unique identifier of the alias"
  value       = aws_bedrockagent_agent_alias.this.agent_alias_id
}

output "id" {
  description = "Alias ID and agent ID separated by ,"
  value       = aws_bedrockagent_agent_alias.this.id
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_bedrockagent_agent_alias.this.tags_all
}