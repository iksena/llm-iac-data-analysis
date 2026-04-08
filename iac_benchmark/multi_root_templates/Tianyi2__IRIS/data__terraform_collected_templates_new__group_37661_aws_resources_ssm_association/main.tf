resource "aws_ssm_association" "this" {
  region                           = var.region
  name                             = var.name
  apply_only_at_cron_interval      = var.apply_only_at_cron_interval
  association_name                 = var.association_name
  automation_target_parameter_name = var.automation_target_parameter_name
  compliance_severity              = var.compliance_severity
  document_version                 = var.document_version
  max_concurrency                  = var.max_concurrency
  max_errors                       = var.max_errors
  schedule_expression              = var.schedule_expression
  sync_compliance                  = var.sync_compliance
  tags                             = var.tags
  wait_for_success_timeout_seconds = var.wait_for_success_timeout_seconds

  dynamic "output_location" {
    for_each = var.output_location != null ? [var.output_location] : []
    content {
      s3_bucket_name = output_location.value.s3_bucket_name
      s3_key_prefix  = output_location.value.s3_key_prefix
      s3_region      = output_location.value.s3_region
    }
  }

  parameters = var.parameters

  dynamic "targets" {
    for_each = var.targets
    content {
      key    = targets.value.key
      values = targets.value.values
    }
  }
}