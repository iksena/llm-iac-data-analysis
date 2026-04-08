output "channel_id" {
  description = "ID of the Microsoft Teams channel"
  value       = aws_chatbot_teams_channel_configuration.this.channel_id
}

output "configuration_name" {
  description = "Name of the Microsoft Teams channel configuration"
  value       = aws_chatbot_teams_channel_configuration.this.configuration_name
}

output "iam_role_arn" {
  description = "ARN of the IAM role that defines the permissions for AWS Chatbot"
  value       = aws_chatbot_teams_channel_configuration.this.iam_role_arn
}

output "team_id" {
  description = "ID of the Microsoft Team authorized with AWS Chatbot"
  value       = aws_chatbot_teams_channel_configuration.this.team_id
}

output "tenant_id" {
  description = "ID of the Microsoft Teams tenant"
  value       = aws_chatbot_teams_channel_configuration.this.tenant_id
}

output "channel_name" {
  description = "Name of the Microsoft Teams channel"
  value       = aws_chatbot_teams_channel_configuration.this.channel_name
}

output "guardrail_policy_arns" {
  description = "List of IAM policy ARNs that are applied as channel guardrails"
  value       = aws_chatbot_teams_channel_configuration.this.guardrail_policy_arns
}

output "logging_level" {
  description = "Logging levels include ERROR, INFO, or NONE"
  value       = aws_chatbot_teams_channel_configuration.this.logging_level
}

output "region" {
  description = "Region where this resource will be managed"
  value       = aws_chatbot_teams_channel_configuration.this.region
}

output "sns_topic_arns" {
  description = "ARNs of the SNS topics that deliver notifications to AWS Chatbot"
  value       = aws_chatbot_teams_channel_configuration.this.sns_topic_arns
}

output "tags" {
  description = "Map of tags assigned to the resource"
  value       = aws_chatbot_teams_channel_configuration.this.tags
}

output "team_name" {
  description = "Name of the Microsoft Teams team"
  value       = aws_chatbot_teams_channel_configuration.this.team_name
}

output "user_authorization_required" {
  description = "Enables use of a user role requirement in your chat configuration"
  value       = aws_chatbot_teams_channel_configuration.this.user_authorization_required
}

output "chat_configuration_arn" {
  description = "ARN of the Microsoft Teams channel configuration"
  value       = aws_chatbot_teams_channel_configuration.this.chat_configuration_arn
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_chatbot_teams_channel_configuration.this.tags_all
}