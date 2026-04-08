resource "aws_glue_job" "this" {
  name                      = var.name
  role_arn                  = var.role_arn
  connections               = var.connections
  default_arguments         = var.default_arguments
  description               = var.description
  execution_class           = var.execution_class
  glue_version              = var.glue_version
  job_mode                  = var.job_mode
  job_run_queuing_enabled   = var.job_run_queuing_enabled
  maintenance_window        = var.maintenance_window
  max_capacity              = var.max_capacity
  max_retries               = var.max_retries
  non_overridable_arguments = var.non_overridable_arguments
  number_of_workers         = var.number_of_workers
  region                    = var.region
  security_configuration    = var.security_configuration
  tags                      = var.tags
  timeout                   = var.timeout
  worker_type               = var.worker_type

  command {
    name            = var.command.name
    script_location = var.command.script_location
    python_version  = var.command.python_version
    runtime         = var.command.runtime
  }

  dynamic "execution_property" {
    for_each = var.execution_property != null ? [var.execution_property] : []
    content {
      max_concurrent_runs = execution_property.value.max_concurrent_runs
    }
  }

  dynamic "notification_property" {
    for_each = var.notification_property != null ? [var.notification_property] : []
    content {
      notify_delay_after = notification_property.value.notify_delay_after
    }
  }

  dynamic "source_control_details" {
    for_each = var.source_control_details != null ? [var.source_control_details] : []
    content {
      auth_strategy  = source_control_details.value.auth_strategy
      auth_token     = source_control_details.value.auth_token
      branch         = source_control_details.value.branch
      folder         = source_control_details.value.folder
      last_commit_id = source_control_details.value.last_commit_id
      owner          = source_control_details.value.owner
      provider       = source_control_details.value.provider
      repository     = source_control_details.value.repository
    }
  }
}