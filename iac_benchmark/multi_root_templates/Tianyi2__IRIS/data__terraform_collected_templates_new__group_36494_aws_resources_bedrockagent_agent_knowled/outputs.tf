output "id" {
  description = "Agent ID, agent version, and knowledge base ID separated by ','."
  value       = aws_bedrockagent_agent_knowledge_base_association.this.id
}

output "agent_id" {
  description = "Unique identifier of the agent with which you want to associate the knowledge base."
  value       = aws_bedrockagent_agent_knowledge_base_association.this.agent_id
}

output "description" {
  description = "Description of what the agent should use the knowledge base for."
  value       = aws_bedrockagent_agent_knowledge_base_association.this.description
}

output "knowledge_base_id" {
  description = "Unique identifier of the knowledge base to associate with the agent."
  value       = aws_bedrockagent_agent_knowledge_base_association.this.knowledge_base_id
}

output "knowledge_base_state" {
  description = "Whether to use the knowledge base when sending an InvokeAgent request."
  value       = aws_bedrockagent_agent_knowledge_base_association.this.knowledge_base_state
}

output "region" {
  description = "Region where this resource is managed."
  value       = aws_bedrockagent_agent_knowledge_base_association.this.region
}

output "agent_version" {
  description = "Version of the agent with which you want to associate the knowledge base."
  value       = aws_bedrockagent_agent_knowledge_base_association.this.agent_version
}