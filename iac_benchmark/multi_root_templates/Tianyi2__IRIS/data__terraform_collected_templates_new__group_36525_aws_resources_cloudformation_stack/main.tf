resource "aws_cloudformation_stack" "this" {
  region             = var.region
  name               = var.name
  template_body      = var.template_body
  template_url       = var.template_url
  capabilities       = var.capabilities
  disable_rollback   = var.disable_rollback
  notification_arns  = var.notification_arns
  on_failure         = var.on_failure
  parameters         = var.parameters
  policy_body        = var.policy_body
  policy_url         = var.policy_url
  tags               = var.tags
  iam_role_arn       = var.iam_role_arn
  timeout_in_minutes = var.timeout_in_minutes

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}