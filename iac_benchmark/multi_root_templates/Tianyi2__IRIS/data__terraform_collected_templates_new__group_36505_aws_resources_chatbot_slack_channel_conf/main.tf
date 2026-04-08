resource "aws_chatbot_slack_channel_configuration" "this" {
  configuration_name          = var.configuration_name
  iam_role_arn                = var.iam_role_arn
  slack_channel_id            = var.slack_channel_id
  slack_team_id               = var.slack_team_id
  region                      = var.region
  guardrail_policy_arns       = var.guardrail_policy_arns
  logging_level               = var.logging_level
  sns_topic_arns              = var.sns_topic_arns
  tags                        = var.tags
  user_authorization_required = var.user_authorization_required

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}