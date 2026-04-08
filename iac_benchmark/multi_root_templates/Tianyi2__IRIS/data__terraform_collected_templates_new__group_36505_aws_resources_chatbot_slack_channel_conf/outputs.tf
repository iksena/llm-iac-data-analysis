output "chat_configuration_arn" {
  description = "ARN of the Slack channel configuration"
  value       = aws_chatbot_slack_channel_configuration.this.chat_configuration_arn
}

output "slack_channel_name" {
  description = "Name of the Slack channel"
  value       = aws_chatbot_slack_channel_configuration.this.slack_channel_name
}

output "slack_team_name" {
  description = "Name of the Slack team"
  value       = aws_chatbot_slack_channel_configuration.this.slack_team_name
}

output "tags_all" {
  description = "Map of tags assigned to the resource, including those inherited from the provider default_tags configuration block"
  value       = aws_chatbot_slack_channel_configuration.this.tags_all
}