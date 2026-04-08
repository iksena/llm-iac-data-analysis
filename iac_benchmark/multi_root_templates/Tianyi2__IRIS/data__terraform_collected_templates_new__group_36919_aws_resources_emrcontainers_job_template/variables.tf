variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The specified name of the job template"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_emrcontainers_job_template, name cannot be empty."
  }
}

variable "kms_key_arn" {
  description = "The KMS key ARN used to encrypt the job template"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "job_template_data" {
  description = "The job template data which holds values of StartJobRun API request"
  type = object({
    execution_role_arn = string
    release_label      = string
    job_tags           = optional(map(string))

    configuration_overrides = optional(object({
      application_configuration = optional(list(object({
        classification = string
        configurations = optional(list(string))
        properties     = optional(map(string))
      })))

      monitoring_configuration = optional(object({
        persistent_app_ui = optional(string)

        cloud_watch_monitoring_configuration = optional(object({
          log_group_name         = string
          log_stream_name_prefix = optional(string)
        }))

        s3_monitoring_configuration = optional(object({
          log_uri = optional(string)
        }))
      }))
    }))

    job_driver = object({
      spark_sql_job_driver = optional(object({
        entry_point          = optional(string)
        spark_sql_parameters = optional(string)
      }))

      spark_submit_job_driver = optional(object({
        entry_point             = string
        entry_point_arguments   = optional(list(string))
        spark_submit_parameters = optional(string)
      }))
    })
  })

  validation {
    condition     = var.job_template_data.execution_role_arn != null && length(var.job_template_data.execution_role_arn) > 0
    error_message = "resource_aws_emrcontainers_job_template, execution_role_arn is required and cannot be empty."
  }

  validation {
    condition     = var.job_template_data.release_label != null && length(var.job_template_data.release_label) > 0
    error_message = "resource_aws_emrcontainers_job_template, release_label is required and cannot be empty."
  }

  validation {
    condition = (
      (var.job_template_data.job_driver.spark_sql_job_driver != null && var.job_template_data.job_driver.spark_submit_job_driver == null) ||
      (var.job_template_data.job_driver.spark_sql_job_driver == null && var.job_template_data.job_driver.spark_submit_job_driver != null)
    )
    error_message = "resource_aws_emrcontainers_job_template, job_driver requires exactly one of spark_sql_job_driver or spark_submit_job_driver."
  }

  validation {
    condition = (
      var.job_template_data.job_driver.spark_submit_job_driver == null ||
      (var.job_template_data.job_driver.spark_submit_job_driver.entry_point != null && length(var.job_template_data.job_driver.spark_submit_job_driver.entry_point) > 0)
    )
    error_message = "resource_aws_emrcontainers_job_template, spark_submit_job_driver.entry_point is required when using spark_submit_job_driver."
  }

  validation {
    condition = (
      var.job_template_data.configuration_overrides == null ||
      var.job_template_data.configuration_overrides.application_configuration == null ||
      alltrue([
        for config in var.job_template_data.configuration_overrides.application_configuration :
        config.classification != null && length(config.classification) > 0
      ])
    )
    error_message = "resource_aws_emrcontainers_job_template, application_configuration.classification is required for each application configuration."
  }

  validation {
    condition = (
      var.job_template_data.configuration_overrides == null ||
      var.job_template_data.configuration_overrides.monitoring_configuration == null ||
      var.job_template_data.configuration_overrides.monitoring_configuration.cloud_watch_monitoring_configuration == null ||
      (var.job_template_data.configuration_overrides.monitoring_configuration.cloud_watch_monitoring_configuration.log_group_name != null &&
      length(var.job_template_data.configuration_overrides.monitoring_configuration.cloud_watch_monitoring_configuration.log_group_name) > 0)
    )
    error_message = "resource_aws_emrcontainers_job_template, cloud_watch_monitoring_configuration.log_group_name is required when using cloud_watch_monitoring_configuration."
  }
}