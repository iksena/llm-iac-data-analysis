data "aws_chatbot_slack_workspace" "this" {
  region          = var.region
  slack_team_name = var.slack_team_name
}