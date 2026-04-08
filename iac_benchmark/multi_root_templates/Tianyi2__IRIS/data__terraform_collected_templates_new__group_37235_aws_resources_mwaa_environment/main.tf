resource "aws_mwaa_environment" "this" {
  name               = var.name
  dag_s3_path        = var.dag_s3_path
  execution_role_arn = var.execution_role_arn
  source_bucket_arn  = var.source_bucket_arn

  airflow_configuration_options    = var.airflow_configuration_options
  airflow_version                  = var.airflow_version
  endpoint_management              = var.endpoint_management
  environment_class                = var.environment_class
  kms_key                          = var.kms_key
  max_webservers                   = var.max_webservers
  max_workers                      = var.max_workers
  min_webservers                   = var.min_webservers
  min_workers                      = var.min_workers
  plugins_s3_object_version        = var.plugins_s3_object_version
  plugins_s3_path                  = var.plugins_s3_path
  requirements_s3_object_version   = var.requirements_s3_object_version
  requirements_s3_path             = var.requirements_s3_path
  schedulers                       = var.schedulers
  startup_script_s3_object_version = var.startup_script_s3_object_version
  startup_script_s3_path           = var.startup_script_s3_path
  webserver_access_mode            = var.webserver_access_mode
  weekly_maintenance_window_start  = var.weekly_maintenance_window_start
  worker_replacement_strategy      = var.worker_replacement_strategy
  tags                             = var.tags

  network_configuration {
    security_group_ids = var.network_configuration.security_group_ids
    subnet_ids         = var.network_configuration.subnet_ids
  }

  dynamic "logging_configuration" {
    for_each = var.logging_configuration != null ? [var.logging_configuration] : []
    content {
      dynamic "dag_processing_logs" {
        for_each = logging_configuration.value.dag_processing_logs != null ? [logging_configuration.value.dag_processing_logs] : []
        content {
          enabled   = dag_processing_logs.value.enabled
          log_level = dag_processing_logs.value.log_level
        }
      }

      dynamic "scheduler_logs" {
        for_each = logging_configuration.value.scheduler_logs != null ? [logging_configuration.value.scheduler_logs] : []
        content {
          enabled   = scheduler_logs.value.enabled
          log_level = scheduler_logs.value.log_level
        }
      }

      dynamic "task_logs" {
        for_each = logging_configuration.value.task_logs != null ? [logging_configuration.value.task_logs] : []
        content {
          enabled   = task_logs.value.enabled
          log_level = task_logs.value.log_level
        }
      }

      dynamic "webserver_logs" {
        for_each = logging_configuration.value.webserver_logs != null ? [logging_configuration.value.webserver_logs] : []
        content {
          enabled   = webserver_logs.value.enabled
          log_level = webserver_logs.value.log_level
        }
      }

      dynamic "worker_logs" {
        for_each = logging_configuration.value.worker_logs != null ? [logging_configuration.value.worker_logs] : []
        content {
          enabled   = worker_logs.value.enabled
          log_level = worker_logs.value.log_level
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}