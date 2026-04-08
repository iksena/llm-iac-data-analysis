resource "aws_lambda_function" "this" {
  function_name = var.function_name
  role          = var.role

  # Deployment package configuration
  filename           = var.filename
  s3_bucket          = var.s3_bucket
  s3_key             = var.s3_key
  s3_object_version  = var.s3_object_version
  image_uri          = var.image_uri
  source_code_hash   = var.source_code_hash
  source_kms_key_arn = var.source_kms_key_arn

  # Function configuration
  package_type                       = var.package_type
  runtime                            = var.runtime
  handler                            = var.handler
  architectures                      = var.architectures
  memory_size                        = var.memory_size
  timeout                            = var.timeout
  description                        = var.description
  layers                             = var.layers
  reserved_concurrent_executions     = var.reserved_concurrent_executions
  publish                            = var.publish
  region                             = var.region
  skip_destroy                       = var.skip_destroy
  kms_key_arn                        = var.kms_key_arn
  code_signing_config_arn            = var.code_signing_config_arn
  replace_security_groups_on_destroy = var.replace_security_groups_on_destroy
  replacement_security_group_ids     = var.replacement_security_group_ids
  tags                               = var.tags

  # Configuration blocks
  dynamic "dead_letter_config" {
    for_each = var.dead_letter_config != null ? [var.dead_letter_config] : []
    content {
      target_arn = dead_letter_config.value.target_arn
    }
  }

  dynamic "environment" {
    for_each = var.environment != null ? [var.environment] : []
    content {
      variables = environment.value.variables
    }
  }

  dynamic "ephemeral_storage" {
    for_each = var.ephemeral_storage != null ? [var.ephemeral_storage] : []
    content {
      size = ephemeral_storage.value.size
    }
  }

  dynamic "file_system_config" {
    for_each = var.file_system_config != null ? [var.file_system_config] : []
    content {
      arn              = file_system_config.value.arn
      local_mount_path = file_system_config.value.local_mount_path
    }
  }

  dynamic "image_config" {
    for_each = var.image_config != null ? [var.image_config] : []
    content {
      command           = image_config.value.command
      entry_point       = image_config.value.entry_point
      working_directory = image_config.value.working_directory
    }
  }

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      log_format            = logging_config.value.log_format
      application_log_level = logging_config.value.application_log_level
      system_log_level      = logging_config.value.system_log_level
      log_group             = logging_config.value.log_group
    }
  }

  dynamic "snap_start" {
    for_each = var.snap_start != null ? [var.snap_start] : []
    content {
      apply_on = snap_start.value.apply_on
    }
  }

  dynamic "tracing_config" {
    for_each = var.tracing_config != null ? [var.tracing_config] : []
    content {
      mode = tracing_config.value.mode
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

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}