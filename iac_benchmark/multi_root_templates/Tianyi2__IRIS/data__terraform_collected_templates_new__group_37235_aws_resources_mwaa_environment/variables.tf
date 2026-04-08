variable "name" {
  description = "The name of the Apache Airflow Environment"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.name))
    error_message = "resource_aws_mwaa_environment, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "dag_s3_path" {
  description = "The relative path to the DAG folder on your Amazon S3 storage bucket. For example, dags."
  type        = string
}

variable "execution_role_arn" {
  description = "The Amazon Resource Name (ARN) of the task execution role that the Amazon MWAA and its environment can assume."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]+:role/.+", var.execution_role_arn))
    error_message = "resource_aws_mwaa_environment, execution_role_arn must be a valid IAM role ARN."
  }
}

variable "source_bucket_arn" {
  description = "The Amazon Resource Name (ARN) of your Amazon S3 storage bucket."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3:::.+", var.source_bucket_arn))
    error_message = "resource_aws_mwaa_environment, source_bucket_arn must be a valid S3 bucket ARN."
  }
}

variable "network_configuration" {
  description = "Specifies the network configuration for your Apache Airflow Environment."
  type = object({
    security_group_ids = list(string)
    subnet_ids         = list(string)
  })

  validation {
    condition     = length(var.network_configuration.subnet_ids) == 2
    error_message = "resource_aws_mwaa_environment, network_configuration subnet_ids must contain exactly 2 subnets."
  }

  validation {
    condition     = length(var.network_configuration.security_group_ids) >= 1
    error_message = "resource_aws_mwaa_environment, network_configuration security_group_ids must contain at least 1 security group."
  }
}

variable "airflow_configuration_options" {
  description = "The airflow_configuration_options parameter specifies airflow override options."
  type        = map(any)
  default     = null
}

variable "airflow_version" {
  description = "Airflow version of your environment, will be set by default to the latest version that MWAA supports."
  type        = string
  default     = null
}

variable "endpoint_management" {
  description = "Defines whether the VPC endpoints configured for the environment are created and managed by the customer or by AWS."
  type        = string
  default     = "SERVICE"

  validation {
    condition     = contains(["SERVICE", "CUSTOMER"], var.endpoint_management)
    error_message = "resource_aws_mwaa_environment, endpoint_management must be either 'SERVICE' or 'CUSTOMER'."
  }
}

variable "environment_class" {
  description = "Environment class for the cluster."
  type        = string
  default     = "mw1.small"

  validation {
    condition     = contains(["mw1.micro", "mw1.small", "mw1.medium", "mw1.large"], var.environment_class)
    error_message = "resource_aws_mwaa_environment, environment_class must be one of: mw1.micro, mw1.small, mw1.medium, mw1.large."
  }
}

variable "kms_key" {
  description = "The Amazon Resource Name (ARN) of your KMS key that you want to use for encryption."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key == null || can(regex("^arn:aws:kms:[a-z0-9-]+:[0-9]+:key/.+", var.kms_key))
    error_message = "resource_aws_mwaa_environment, kms_key must be a valid KMS key ARN when provided."
  }
}

variable "max_webservers" {
  description = "The maximum number of web servers that you want to run in your environment."
  type        = number
  default     = null

  validation {
    condition = var.max_webservers == null || (
      var.environment_class == "mw1.micro" ?
      var.max_webservers == 1 :
      var.max_webservers >= 2 && var.max_webservers <= 5
    )
    error_message = "resource_aws_mwaa_environment, max_webservers must be 1 for mw1.micro environment_class, or between 2-5 for other classes."
  }
}

variable "max_workers" {
  description = "The maximum number of workers that can be automatically scaled up."
  type        = number
  default     = 10

  validation {
    condition     = var.max_workers >= 1 && var.max_workers <= 25
    error_message = "resource_aws_mwaa_environment, max_workers must be between 1 and 25."
  }
}

variable "min_webservers" {
  description = "The minimum number of web servers that you want to run in your environment."
  type        = number
  default     = null

  validation {
    condition = var.min_webservers == null || (
      var.environment_class == "mw1.micro" ?
      var.min_webservers == 1 :
      var.min_webservers >= 2 && var.min_webservers <= 5
    )
    error_message = "resource_aws_mwaa_environment, min_webservers must be 1 for mw1.micro environment_class, or between 2-5 for other classes."
  }
}

variable "min_workers" {
  description = "The minimum number of workers that you want to run in your environment."
  type        = number
  default     = 1
}

variable "plugins_s3_object_version" {
  description = "The plugins.zip file version you want to use."
  type        = string
  default     = null
}

variable "plugins_s3_path" {
  description = "The relative path to the plugins.zip file on your Amazon S3 storage bucket."
  type        = string
  default     = null
}

variable "requirements_s3_object_version" {
  description = "The requirements.txt file version you want to use."
  type        = string
  default     = null
}

variable "requirements_s3_path" {
  description = "The relative path to the requirements.txt file on your Amazon S3 storage bucket."
  type        = string
  default     = null
}

variable "schedulers" {
  description = "The number of schedulers that you want to run in your environment."
  type        = number
  default     = 2

  validation {
    condition     = var.schedulers >= 1 && var.schedulers <= 5
    error_message = "resource_aws_mwaa_environment, schedulers must be between 1 and 5."
  }
}

variable "startup_script_s3_object_version" {
  description = "The version of the startup shell script you want to use."
  type        = string
  default     = null
}

variable "startup_script_s3_path" {
  description = "The relative path to the script hosted in your bucket."
  type        = string
  default     = null
}

variable "webserver_access_mode" {
  description = "Specifies whether the webserver should be accessible over the internet or via your specified VPC."
  type        = string
  default     = "PRIVATE_ONLY"

  validation {
    condition     = contains(["PRIVATE_ONLY", "PUBLIC_ONLY"], var.webserver_access_mode)
    error_message = "resource_aws_mwaa_environment, webserver_access_mode must be either 'PRIVATE_ONLY' or 'PUBLIC_ONLY'."
  }
}

variable "weekly_maintenance_window_start" {
  description = "Specifies the start date for the weekly maintenance window."
  type        = string
  default     = null
}

variable "worker_replacement_strategy" {
  description = "Worker replacement strategy."
  type        = string
  default     = null

  validation {
    condition     = var.worker_replacement_strategy == null || contains(["FORCED", "GRACEFUL"], var.worker_replacement_strategy)
    error_message = "resource_aws_mwaa_environment, worker_replacement_strategy must be either 'FORCED' or 'GRACEFUL' when provided."
  }
}

variable "tags" {
  description = "A map of resource tags to associate with the resource."
  type        = map(string)
  default     = {}
}

variable "logging_configuration" {
  description = "The Apache Airflow logs you want to send to Amazon CloudWatch Logs."
  type = object({
    dag_processing_logs = optional(object({
      enabled   = bool
      log_level = optional(string, "INFO")
    }))
    scheduler_logs = optional(object({
      enabled   = bool
      log_level = optional(string, "INFO")
    }))
    task_logs = optional(object({
      enabled   = bool
      log_level = optional(string, "INFO")
    }))
    webserver_logs = optional(object({
      enabled   = bool
      log_level = optional(string, "INFO")
    }))
    worker_logs = optional(object({
      enabled   = bool
      log_level = optional(string, "INFO")
    }))
  })
  default = null

  validation {
    condition = var.logging_configuration == null || alltrue([
      for log_config in [
        var.logging_configuration.dag_processing_logs,
        var.logging_configuration.scheduler_logs,
        var.logging_configuration.task_logs,
        var.logging_configuration.webserver_logs,
        var.logging_configuration.worker_logs
      ] : log_config == null || contains(["CRITICAL", "ERROR", "WARNING", "INFO", "DEBUG"], log_config.log_level)
    ])
    error_message = "resource_aws_mwaa_environment, logging_configuration log_level must be one of: CRITICAL, ERROR, WARNING, INFO, DEBUG."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource operations."
  type = object({
    create = optional(string, "120m")
    update = optional(string, "90m")
    delete = optional(string, "90m")
  })
  default = {
    create = "120m"
    update = "90m"
    delete = "90m"
  }
}