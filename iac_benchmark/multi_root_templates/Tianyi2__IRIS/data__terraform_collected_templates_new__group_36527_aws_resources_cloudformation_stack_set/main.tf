resource "aws_cloudformation_stack_set" "this" {
  region                  = var.region
  administration_role_arn = var.administration_role_arn
  name                    = var.name
  capabilities            = var.capabilities
  description             = var.description
  execution_role_name     = var.execution_role_name
  parameters              = var.parameters
  permission_model        = var.permission_model
  call_as                 = var.call_as
  tags                    = var.tags
  template_body           = var.template_body
  template_url            = var.template_url

  dynamic "auto_deployment" {
    for_each = var.auto_deployment != null ? [var.auto_deployment] : []
    content {
      enabled                          = auto_deployment.value.enabled
      retain_stacks_on_account_removal = auto_deployment.value.retain_stacks_on_account_removal
    }
  }

  dynamic "managed_execution" {
    for_each = var.managed_execution != null ? [var.managed_execution] : []
    content {
      active = managed_execution.value.active
    }
  }

  dynamic "operation_preferences" {
    for_each = var.operation_preferences != null ? [var.operation_preferences] : []
    content {
      failure_tolerance_count      = operation_preferences.value.failure_tolerance_count
      failure_tolerance_percentage = operation_preferences.value.failure_tolerance_percentage
      max_concurrent_count         = operation_preferences.value.max_concurrent_count
      max_concurrent_percentage    = operation_preferences.value.max_concurrent_percentage
      region_concurrency_type      = operation_preferences.value.region_concurrency_type
      region_order                 = operation_preferences.value.region_order
    }
  }

  timeouts {
    update = var.timeouts_update
  }
}