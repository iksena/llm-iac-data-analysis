variable "name" {
  description = "The name of the connector"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_mskconnect_connector, name must be a non-empty string."
  }
}

variable "kafkaconnect_version" {
  description = "The version of Kafka Connect. It has to be compatible with both the Apache Kafka cluster's version and the plugins"
  type        = string

  validation {
    condition     = length(var.kafkaconnect_version) > 0
    error_message = "resource_aws_mskconnect_connector, kafkaconnect_version must be a non-empty string."
  }
}

variable "connector_configuration" {
  description = "A map of keys to values that represent the configuration for the connector"
  type        = map(string)

  validation {
    condition     = length(var.connector_configuration) > 0
    error_message = "resource_aws_mskconnect_connector, connector_configuration must contain at least one key-value pair."
  }
}

variable "service_execution_role_arn" {
  description = "The Amazon Resource Name (ARN) of the IAM role used by the connector to access the Amazon Web Services resources that it needs"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.service_execution_role_arn))
    error_message = "resource_aws_mskconnect_connector, service_execution_role_arn must be a valid IAM role ARN."
  }
}

variable "capacity" {
  description = "Information about the capacity allocated to the connector"
  type = object({
    autoscaling = optional(object({
      max_worker_count = number
      min_worker_count = number
      mcu_count        = optional(number, 1)
      scale_in_policy = optional(object({
        cpu_utilization_percentage = number
      }))
      scale_out_policy = optional(object({
        cpu_utilization_percentage = number
      }))
    }))
    provisioned_capacity = optional(object({
      worker_count = number
      mcu_count    = optional(number, 1)
    }))
  })

  validation {
    condition = (
      var.capacity.autoscaling != null || var.capacity.provisioned_capacity != null
    )
    error_message = "resource_aws_mskconnect_connector, capacity must specify either autoscaling or provisioned_capacity."
  }

  validation {
    condition = !(
      var.capacity.autoscaling != null && var.capacity.provisioned_capacity != null
    )
    error_message = "resource_aws_mskconnect_connector, capacity cannot specify both autoscaling and provisioned_capacity."
  }

  validation {
    condition = var.capacity.autoscaling == null ? true : (
      var.capacity.autoscaling.mcu_count == null || contains([1, 2, 4, 8], var.capacity.autoscaling.mcu_count)
    )
    error_message = "resource_aws_mskconnect_connector, capacity autoscaling mcu_count must be one of: 1, 2, 4, 8."
  }

  validation {
    condition = var.capacity.provisioned_capacity == null ? true : (
      var.capacity.provisioned_capacity.mcu_count == null || contains([1, 2, 4, 8], var.capacity.provisioned_capacity.mcu_count)
    )
    error_message = "resource_aws_mskconnect_connector, capacity provisioned_capacity mcu_count must be one of: 1, 2, 4, 8."
  }

  validation {
    condition = var.capacity.autoscaling == null ? true : (
      var.capacity.autoscaling.max_worker_count >= var.capacity.autoscaling.min_worker_count
    )
    error_message = "resource_aws_mskconnect_connector, capacity autoscaling max_worker_count must be greater than or equal to min_worker_count."
  }

  validation {
    condition = var.capacity.autoscaling == null ? true : (
      var.capacity.autoscaling.scale_in_policy == null || (
        var.capacity.autoscaling.scale_in_policy.cpu_utilization_percentage >= 1 &&
        var.capacity.autoscaling.scale_in_policy.cpu_utilization_percentage <= 100
      )
    )
    error_message = "resource_aws_mskconnect_connector, capacity autoscaling scale_in_policy cpu_utilization_percentage must be between 1 and 100."
  }

  validation {
    condition = var.capacity.autoscaling == null ? true : (
      var.capacity.autoscaling.scale_out_policy == null || (
        var.capacity.autoscaling.scale_out_policy.cpu_utilization_percentage >= 1 &&
        var.capacity.autoscaling.scale_out_policy.cpu_utilization_percentage <= 100
      )
    )
    error_message = "resource_aws_mskconnect_connector, capacity autoscaling scale_out_policy cpu_utilization_percentage must be between 1 and 100."
  }

  validation {
    condition = var.capacity.provisioned_capacity == null ? true : (
      var.capacity.provisioned_capacity.worker_count > 0
    )
    error_message = "resource_aws_mskconnect_connector, capacity provisioned_capacity worker_count must be greater than 0."
  }
}

variable "kafka_cluster" {
  description = "Specifies which Apache Kafka cluster to connect to"
  type = object({
    apache_kafka_cluster = object({
      bootstrap_servers = string
      vpc = object({
        security_groups = list(string)
        subnets         = list(string)
      })
    })
  })

  validation {
    condition     = length(var.kafka_cluster.apache_kafka_cluster.bootstrap_servers) > 0
    error_message = "resource_aws_mskconnect_connector, kafka_cluster apache_kafka_cluster bootstrap_servers must be a non-empty string."
  }

  validation {
    condition     = length(var.kafka_cluster.apache_kafka_cluster.vpc.security_groups) > 0
    error_message = "resource_aws_mskconnect_connector, kafka_cluster apache_kafka_cluster vpc security_groups must contain at least one security group."
  }

  validation {
    condition     = length(var.kafka_cluster.apache_kafka_cluster.vpc.subnets) > 0
    error_message = "resource_aws_mskconnect_connector, kafka_cluster apache_kafka_cluster vpc subnets must contain at least one subnet."
  }
}

variable "kafka_cluster_client_authentication" {
  description = "Details of the client authentication used by the Apache Kafka cluster"
  type = object({
    authentication_type = optional(string, "NONE")
  })

  validation {
    condition     = contains(["IAM", "NONE"], var.kafka_cluster_client_authentication.authentication_type)
    error_message = "resource_aws_mskconnect_connector, kafka_cluster_client_authentication authentication_type must be either 'IAM' or 'NONE'."
  }
}

variable "kafka_cluster_encryption_in_transit" {
  description = "Details of encryption in transit to the Apache Kafka cluster"
  type = object({
    encryption_type = optional(string, "PLAINTEXT")
  })

  validation {
    condition     = contains(["PLAINTEXT", "TLS"], var.kafka_cluster_encryption_in_transit.encryption_type)
    error_message = "resource_aws_mskconnect_connector, kafka_cluster_encryption_in_transit encryption_type must be either 'PLAINTEXT' or 'TLS'."
  }
}

variable "plugin" {
  description = "Specifies which plugins to use for the connector"
  type = object({
    custom_plugin = object({
      arn      = string
      revision = number
    })
  })

  validation {
    condition     = can(regex("^arn:aws:kafkaconnect:", var.plugin.custom_plugin.arn))
    error_message = "resource_aws_mskconnect_connector, plugin custom_plugin arn must be a valid MSK Connect custom plugin ARN."
  }

  validation {
    condition     = var.plugin.custom_plugin.revision > 0
    error_message = "resource_aws_mskconnect_connector, plugin custom_plugin revision must be a positive integer."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "A summary description of the connector"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "log_delivery" {
  description = "Details about log delivery"
  type = object({
    worker_log_delivery = object({
      cloudwatch_logs = optional(object({
        enabled   = optional(bool)
        log_group = string
      }))
      firehose = optional(object({
        delivery_stream = optional(string)
        enabled         = bool
      }))
      s3 = optional(object({
        bucket  = optional(string)
        enabled = bool
        prefix  = optional(string)
      }))
    })
  })
  default = null

  validation {
    condition = var.log_delivery == null ? true : (
      var.log_delivery.worker_log_delivery.cloudwatch_logs != null ||
      var.log_delivery.worker_log_delivery.firehose != null ||
      var.log_delivery.worker_log_delivery.s3 != null
    )
    error_message = "resource_aws_mskconnect_connector, log_delivery worker_log_delivery must specify at least one destination: cloudwatch_logs, firehose, or s3."
  }

  validation {
    condition = var.log_delivery == null ? true : (
      var.log_delivery.worker_log_delivery.cloudwatch_logs == null ||
      length(var.log_delivery.worker_log_delivery.cloudwatch_logs.log_group) > 0
    )
    error_message = "resource_aws_mskconnect_connector, log_delivery worker_log_delivery cloudwatch_logs log_group must be a non-empty string."
  }
}

variable "worker_configuration" {
  description = "Specifies which worker configuration to use with the connector"
  type = object({
    arn      = string
    revision = number
  })
  default = null

  validation {
    condition = var.worker_configuration == null ? true : (
      can(regex("^arn:aws:kafkaconnect:", var.worker_configuration.arn))
    )
    error_message = "resource_aws_mskconnect_connector, worker_configuration arn must be a valid MSK Connect worker configuration ARN."
  }

  validation {
    condition = var.worker_configuration == null ? true : (
      var.worker_configuration.revision > 0
    )
    error_message = "resource_aws_mskconnect_connector, worker_configuration revision must be a positive integer."
  }
}