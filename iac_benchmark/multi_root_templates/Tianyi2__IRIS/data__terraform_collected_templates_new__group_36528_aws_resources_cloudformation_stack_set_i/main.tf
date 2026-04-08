resource "aws_cloudformation_stack_set_instance" "this" {
  stack_set_name            = var.stack_set_name
  account_id                = var.account_id
  call_as                   = var.call_as
  parameter_overrides       = var.parameter_overrides
  retain_stack              = var.retain_stack
  stack_set_instance_region = var.stack_set_instance_region

  dynamic "deployment_targets" {
    for_each = var.deployment_targets != null ? [var.deployment_targets] : []
    content {
      organizational_unit_ids = deployment_targets.value.organizational_unit_ids
      account_filter_type     = deployment_targets.value.account_filter_type
      accounts                = deployment_targets.value.accounts
      accounts_url            = deployment_targets.value.accounts_url
    }
  }

  dynamic "operation_preferences" {
    for_each = var.operation_preferences != null ? [var.operation_preferences] : []
    content {
      failure_tolerance_count      = operation_preferences.value.failure_tolerance_count
      failure_tolerance_percentage = operation_preferences.value.failure_tolerance_percentage
      max_concurrent_count         = operation_preferences.value.max_concurrent_count
      max_concurrent_percentage    = operation_preferences.value.max_concurrent_percentage
      concurrency_mode             = operation_preferences.value.concurrency_mode
      region_concurrency_type      = operation_preferences.value.region_concurrency_type
      region_order                 = operation_preferences.value.region_order
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}