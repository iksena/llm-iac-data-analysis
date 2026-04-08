output "action_group_id" {
  description = "Unique identifier of the action group."
  value       = aws_bedrockagent_agent_action_group.this.action_group_id
}

output "id" {
  description = "Action group ID, agent ID, and agent version separated by `,`."
  value       = aws_bedrockagent_agent_action_group.this.id
}