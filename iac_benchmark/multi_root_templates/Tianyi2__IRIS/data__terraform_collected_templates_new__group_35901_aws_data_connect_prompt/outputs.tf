output "region" {
  description = "Region where this resource is managed"
  value       = data.aws_connect_prompt.this.region
}

output "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  value       = data.aws_connect_prompt.this.instance_id
}

output "name" {
  description = "Name of the specific Prompt"
  value       = data.aws_connect_prompt.this.name
}

output "arn" {
  description = "ARN of the Prompt"
  value       = data.aws_connect_prompt.this.arn
}

output "prompt_id" {
  description = "Identifier for the prompt"
  value       = data.aws_connect_prompt.this.prompt_id
}