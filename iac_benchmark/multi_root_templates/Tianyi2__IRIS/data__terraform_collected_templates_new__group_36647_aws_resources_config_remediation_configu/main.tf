resource "aws_config_remediation_configuration" "this" {
  config_rule_name = var.config_rule_name
  target_id        = var.target_id
  target_type      = var.target_type

  region                     = var.region
  automatic                  = var.automatic
  maximum_automatic_attempts = var.maximum_automatic_attempts
  resource_type              = var.resource_type
  retry_attempt_seconds      = var.retry_attempt_seconds
  target_version             = var.target_version

  dynamic "execution_controls" {
    for_each = var.execution_controls != null ? [var.execution_controls] : []
    content {
      ssm_controls {
        concurrent_execution_rate_percentage = execution_controls.value.ssm_controls.concurrent_execution_rate_percentage
        error_percentage                     = execution_controls.value.ssm_controls.error_percentage
      }
    }
  }

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name           = parameter.value.name
      resource_value = parameter.value.resource_value
      static_value   = parameter.value.static_value
      static_values  = parameter.value.static_values
    }
  }
}