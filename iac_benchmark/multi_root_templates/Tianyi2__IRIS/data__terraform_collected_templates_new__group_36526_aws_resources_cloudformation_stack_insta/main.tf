resource "aws_cloudformation_stack_instances" "this" {
  stack_set_name = var.stack_set_name

  region = var.region

  accounts = var.accounts

  dynamic "deployment_targets" {
    for_each = var.deployment_targets != null ? [var.deployment_targets] : []

    content {
      account_filter_type     = deployment_targets.value.account_filter_type
      accounts                = deployment_targets.value.accounts
      accounts_url            = deployment_targets.value.accounts_url
      organizational_unit_ids = deployment_targets.value.organizational_unit_ids
    }
  }

  parameter_overrides = var.parameter_overrides

  regions = var.regions

  retain_stacks = var.retain_stacks

  call_as = var.call_as

  dynamic "operation_preferences" {
    for_each = var.operation_preferences != null ? [var.operation_preferences] : []

    content {
      concurrency_mode             = operation_preferences.value.concurrency_mode
      failure_tolerance_count      = operation_preferences.value.failure_tolerance_count
      failure_tolerance_percentage = operation_preferences.value.failure_tolerance_percentage
      max_concurrent_count         = operation_preferences.value.max_concurrent_count
      max_concurrent_percentage    = operation_preferences.value.max_concurrent_percentage
      region_concurrency_type      = operation_preferences.value.region_concurrency_type
      region_order                 = operation_preferences.value.region_order
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}