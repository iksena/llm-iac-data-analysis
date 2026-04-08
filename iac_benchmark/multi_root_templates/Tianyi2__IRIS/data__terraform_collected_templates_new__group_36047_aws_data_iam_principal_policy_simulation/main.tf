data "aws_iam_principal_policy_simulation" "this" {
  action_names      = var.action_names
  policy_source_arn = var.policy_source_arn

  caller_arn                         = var.caller_arn
  additional_policies_json           = var.additional_policies_json
  permissions_boundary_policies_json = var.permissions_boundary_policies_json
  resource_arns                      = var.resource_arns
  resource_handling_option           = var.resource_handling_option
  resource_owner_account_id          = var.resource_owner_account_id
  resource_policy_json               = var.resource_policy_json

  dynamic "context" {
    for_each = var.context
    content {
      key    = context.value.key
      type   = context.value.type
      values = context.value.values
    }
  }
}