output "agent_arn" {
  description = "ARN of the agent"
  value       = aws_bedrockagent_agent.this.agent_arn
}

output "agent_id" {
  description = "Unique identifier of the agent"
  value       = aws_bedrockagent_agent.this.agent_id
}

output "agent_version" {
  description = "Version of the agent"
  value       = aws_bedrockagent_agent.this.agent_version
}

output "id" {
  description = "Unique identifier of the agent"
  value       = aws_bedrockagent_agent.this.id
}

output "prepared_at" {
  description = "Timestamp of when the agent was last prepared"
  value       = aws_bedrockagent_agent.this.prepared_at
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_bedrockagent_agent.this.tags_all
}