output "arn" {
  description = "The ARN of the response plan."
  value       = aws_ssmincidents_response_plan.this.arn
}

output "tags_all" {
  description = "A map of tags assigned to the resource, including those inherited from the provider default_tags configuration block."
  value       = aws_ssmincidents_response_plan.this.tags_all
}

output "region" {
  description = "Region where this resource will be managed."
  value       = aws_ssmincidents_response_plan.this.region
}

output "name" {
  description = "The name of the response plan."
  value       = aws_ssmincidents_response_plan.this.name
}

output "display_name" {
  description = "The long format of the response plan name."
  value       = aws_ssmincidents_response_plan.this.display_name
}

output "chat_channel" {
  description = "The Chatbot chat channel used for collaboration during an incident."
  value       = aws_ssmincidents_response_plan.this.chat_channel
}

output "engagements" {
  description = "The Amazon Resource Name (ARN) for the contacts and escalation plans that the response plan engages during an incident."
  value       = aws_ssmincidents_response_plan.this.engagements
}

output "tags" {
  description = "The tags applied to the response plan."
  value       = aws_ssmincidents_response_plan.this.tags
}

output "incident_template" {
  description = "The incident template configuration."
  value       = aws_ssmincidents_response_plan.this.incident_template
}

output "action" {
  description = "The actions that the response plan starts at the beginning of an incident."
  value       = aws_ssmincidents_response_plan.this.action
}

output "integration" {
  description = "Information about third-party services integrated into the response plan."
  value       = aws_ssmincidents_response_plan.this.integration
}