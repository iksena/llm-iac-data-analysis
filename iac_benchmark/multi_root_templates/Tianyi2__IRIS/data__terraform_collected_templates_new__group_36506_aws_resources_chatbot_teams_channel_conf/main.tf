resource "aws_chatbot_teams_channel_configuration" "this" {
  channel_id         = var.channel_id
  configuration_name = var.configuration_name
  iam_role_arn       = var.iam_role_arn
  team_id            = var.team_id
  tenant_id          = var.tenant_id

  channel_name                = var.channel_name
  guardrail_policy_arns       = var.guardrail_policy_arns
  logging_level               = var.logging_level
  region                      = var.region
  sns_topic_arns              = var.sns_topic_arns
  tags                        = var.tags
  team_name                   = var.team_name
  user_authorization_required = var.user_authorization_required

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}