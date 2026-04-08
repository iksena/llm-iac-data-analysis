resource "aws_synthetics_canary" "this" {
  name                     = var.name
  artifact_s3_location     = var.artifact_s3_location
  execution_role_arn       = var.execution_role_arn
  handler                  = var.handler
  runtime_version          = var.runtime_version
  region                   = var.region
  delete_lambda            = var.delete_lambda
  failure_retention_period = var.failure_retention_period
  s3_bucket                = var.s3_bucket
  s3_key                   = var.s3_key
  s3_version               = var.s3_version
  start_canary             = var.start_canary
  success_retention_period = var.success_retention_period
  tags                     = var.tags
  zip_file                 = var.zip_file

  schedule {
    expression          = var.schedule.expression
    duration_in_seconds = var.schedule.duration_in_seconds

    dynamic "retry_config" {
      for_each = var.schedule.retry_config != null ? [var.schedule.retry_config] : []
      content {
        max_retries = retry_config.value.max_retries
      }
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      subnet_ids                  = vpc_config.value.subnet_ids
      security_group_ids          = vpc_config.value.security_group_ids
      ipv6_allowed_for_dual_stack = vpc_config.value.ipv6_allowed_for_dual_stack
    }
  }

  dynamic "run_config" {
    for_each = var.run_config != null ? [var.run_config] : []
    content {
      timeout_in_seconds    = run_config.value.timeout_in_seconds
      memory_in_mb          = run_config.value.memory_in_mb
      active_tracing        = run_config.value.active_tracing
      environment_variables = run_config.value.environment_variables
      ephemeral_storage     = run_config.value.ephemeral_storage
    }
  }

  dynamic "artifact_config" {
    for_each = var.artifact_config != null ? [var.artifact_config] : []
    content {
      dynamic "s3_encryption" {
        for_each = artifact_config.value.s3_encryption != null ? [artifact_config.value.s3_encryption] : []
        content {
          encryption_mode = s3_encryption.value.encryption_mode
          kms_key_arn     = s3_encryption.value.kms_key_arn
        }
      }
    }
  }
}