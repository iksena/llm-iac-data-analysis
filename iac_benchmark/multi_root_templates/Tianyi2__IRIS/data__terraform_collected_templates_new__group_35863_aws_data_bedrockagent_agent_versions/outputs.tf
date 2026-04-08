output "agent_version_summaries" {
  description = "List of objects, each of which contains information about a version of the agent."
  value       = data.aws_bedrockagent_agent_versions.this.agent_version_summaries
}

output "agent_name" {
  description = "Name of agent to which the version belongs."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].agent_name, [])
}

output "agent_status" {
  description = "Status of the agent to which the version belongs."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].agent_status, [])
}

output "agent_version" {
  description = "Version of the agent."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].agent_version, [])
}

output "created_at" {
  description = "Time at which the version was created."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].created_at, [])
}

output "updated_at" {
  description = "Time at which the version was last updated."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].updated_at, [])
}

output "description" {
  description = "Description of the version of the agent."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].description, [])
}

output "guardrail_configuration" {
  description = "Details about the guardrail associated with the agent."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].GuardrailConfiguration, [])
}

output "guardrail_identifier" {
  description = "Unique identifier of the guardrail."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].GuardrailConfiguration[*].guardrail_identifier, [])
}

output "guardrail_version" {
  description = "Version of the guardrail."
  value       = try(data.aws_bedrockagent_agent_versions.this.agent_version_summaries[*].GuardrailConfiguration[*].guardrail_version, [])
}