output "arn" {
  description = "Amazon Resource Name (ARN) of the prompt."
  value       = aws_bedrockagent_prompt.this.arn
}

output "id" {
  description = "Unique identifier of the prompt."
  value       = aws_bedrockagent_prompt.this.id
}

output "version" {
  description = "Version of the prompt. When you create a prompt, the version created is the DRAFT version."
  value       = aws_bedrockagent_prompt.this.version
}

output "created_at" {
  description = "Time at which the prompt was created."
  value       = aws_bedrockagent_prompt.this.created_at
}

output "updated_at" {
  description = "Time at which the prompt was last updated."
  value       = aws_bedrockagent_prompt.this.updated_at
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_bedrockagent_prompt.this.tags_all
}