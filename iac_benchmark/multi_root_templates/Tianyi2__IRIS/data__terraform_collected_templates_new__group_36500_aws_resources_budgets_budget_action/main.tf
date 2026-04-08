resource "aws_budgets_budget_action" "this" {
  account_id         = var.account_id
  budget_name        = var.budget_name
  action_type        = var.action_type
  approval_model     = var.approval_model
  notification_type  = var.notification_type
  execution_role_arn = var.execution_role_arn

  action_threshold {
    action_threshold_type  = var.action_threshold.action_threshold_type
    action_threshold_value = var.action_threshold.action_threshold_value
  }

  dynamic "definition" {
    for_each = var.definition != null ? [var.definition] : []
    content {
      dynamic "iam_action_definition" {
        for_each = definition.value.iam_action_definition != null ? [definition.value.iam_action_definition] : []
        content {
          policy_arn = iam_action_definition.value.policy_arn
          groups     = iam_action_definition.value.groups
          roles      = iam_action_definition.value.roles
          users      = iam_action_definition.value.users
        }
      }

      dynamic "scp_action_definition" {
        for_each = definition.value.scp_action_definition != null ? [definition.value.scp_action_definition] : []
        content {
          policy_id  = scp_action_definition.value.policy_id
          target_ids = scp_action_definition.value.target_ids
        }
      }

      dynamic "ssm_action_definition" {
        for_each = definition.value.ssm_action_definition != null ? [definition.value.ssm_action_definition] : []
        content {
          action_sub_type = ssm_action_definition.value.action_sub_type
          instance_ids    = ssm_action_definition.value.instance_ids
          region          = ssm_action_definition.value.region
        }
      }
    }
  }

  dynamic "subscriber" {
    for_each = var.subscriber
    content {
      address           = subscriber.value.address
      subscription_type = subscriber.value.subscription_type
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
  }
}