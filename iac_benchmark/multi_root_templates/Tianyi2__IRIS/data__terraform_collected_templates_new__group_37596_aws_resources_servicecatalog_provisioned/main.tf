resource "aws_servicecatalog_provisioned_product" "this" {
  name                       = var.name
  region                     = var.region
  accept_language            = var.accept_language
  ignore_errors              = var.ignore_errors
  notification_arns          = var.notification_arns
  path_id                    = var.path_id
  path_name                  = var.path_name
  product_id                 = var.product_id
  product_name               = var.product_name
  provisioning_artifact_id   = var.provisioning_artifact_id
  provisioning_artifact_name = var.provisioning_artifact_name
  retain_physical_resources  = var.retain_physical_resources
  tags                       = var.tags

  dynamic "provisioning_parameters" {
    for_each = var.provisioning_parameters
    content {
      key                = provisioning_parameters.value.key
      use_previous_value = provisioning_parameters.value.use_previous_value
      value              = provisioning_parameters.value.value
    }
  }

  dynamic "stack_set_provisioning_preferences" {
    for_each = var.stack_set_provisioning_preferences != null ? [var.stack_set_provisioning_preferences] : []
    content {
      accounts                     = stack_set_provisioning_preferences.value.accounts
      failure_tolerance_count      = stack_set_provisioning_preferences.value.failure_tolerance_count
      failure_tolerance_percentage = stack_set_provisioning_preferences.value.failure_tolerance_percentage
      max_concurrency_count        = stack_set_provisioning_preferences.value.max_concurrency_count
      max_concurrency_percentage   = stack_set_provisioning_preferences.value.max_concurrency_percentage
      regions                      = stack_set_provisioning_preferences.value.regions
    }
  }
}