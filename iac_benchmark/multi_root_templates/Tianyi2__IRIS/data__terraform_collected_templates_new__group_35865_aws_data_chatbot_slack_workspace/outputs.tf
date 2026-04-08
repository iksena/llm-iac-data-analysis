output "region" {
  description = "Region where this resource will be managed."
  value       = data.aws_chatbot_slack_workspace.this.region
}

output "slack_team_name" {
  description = "Slack workspace name configured with AWS Chatbot."
  value       = data.aws_chatbot_slack_workspace.this.slack_team_name
}

output "slack_team_id" {
  description = "ID of the Slack Workspace assigned by AWS Chatbot."
  value       = data.aws_chatbot_slack_workspace.this.slack_team_id
}