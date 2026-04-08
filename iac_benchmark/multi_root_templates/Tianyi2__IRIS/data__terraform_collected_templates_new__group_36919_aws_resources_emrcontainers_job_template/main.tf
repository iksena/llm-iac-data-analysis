resource "aws_emrcontainers_job_template" "this" {
  region      = var.region
  name        = var.name
  kms_key_arn = var.kms_key_arn
  tags        = var.tags

  job_template_data {
    execution_role_arn = var.job_template_data.execution_role_arn
    release_label      = var.job_template_data.release_label
    job_tags           = var.job_template_data.job_tags

    dynamic "configuration_overrides" {
      for_each = var.job_template_data.configuration_overrides != null ? [var.job_template_data.configuration_overrides] : []
      content {
        dynamic "application_configuration" {
          for_each = configuration_overrides.value.application_configuration != null ? configuration_overrides.value.application_configuration : []
          content {
            classification = application_configuration.value.classification
            properties     = application_configuration.value.properties

            dynamic "configurations" {
              for_each = application_configuration.value.configurations != null ? application_configuration.value.configurations : []
              content {
                classification = configurations.value.classification
                properties     = configurations.value.properties
              }
            }
          }
        }

        dynamic "monitoring_configuration" {
          for_each = configuration_overrides.value.monitoring_configuration != null ? [configuration_overrides.value.monitoring_configuration] : []
          content {
            persistent_app_ui = monitoring_configuration.value.persistent_app_ui

            dynamic "cloud_watch_monitoring_configuration" {
              for_each = monitoring_configuration.value.cloud_watch_monitoring_configuration != null ? [monitoring_configuration.value.cloud_watch_monitoring_configuration] : []
              content {
                log_group_name         = cloud_watch_monitoring_configuration.value.log_group_name
                log_stream_name_prefix = cloud_watch_monitoring_configuration.value.log_stream_name_prefix
              }
            }

            dynamic "s3_monitoring_configuration" {
              for_each = monitoring_configuration.value.s3_monitoring_configuration != null ? [monitoring_configuration.value.s3_monitoring_configuration] : []
              content {
                log_uri = s3_monitoring_configuration.value.log_uri
              }
            }
          }
        }
      }
    }

    job_driver {
      dynamic "spark_sql_job_driver" {
        for_each = var.job_template_data.job_driver.spark_sql_job_driver != null ? [var.job_template_data.job_driver.spark_sql_job_driver] : []
        content {
          entry_point          = spark_sql_job_driver.value.entry_point
          spark_sql_parameters = spark_sql_job_driver.value.spark_sql_parameters
        }
      }

      dynamic "spark_submit_job_driver" {
        for_each = var.job_template_data.job_driver.spark_submit_job_driver != null ? [var.job_template_data.job_driver.spark_submit_job_driver] : []
        content {
          entry_point             = spark_submit_job_driver.value.entry_point
          entry_point_arguments   = spark_submit_job_driver.value.entry_point_arguments
          spark_submit_parameters = spark_submit_job_driver.value.spark_submit_parameters
        }
      }
    }
  }
}