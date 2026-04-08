variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the MSK cluster"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]{1,64}$", var.cluster_name))
    error_message = "resource_aws_msk_cluster, cluster_name must be 1-64 characters long and contain only alphanumeric characters, periods, hyphens, and underscores."
  }
}

variable "kafka_version" {
  description = "Specify the desired Kafka software version"
  type        = string

  validation {
    condition     = var.kafka_version != ""
    error_message = "resource_aws_msk_cluster, kafka_version cannot be empty."
  }
}

variable "number_of_broker_nodes" {
  description = "The desired total number of broker nodes in the kafka cluster. It must be a multiple of the number of specified client subnets"
  type        = number

  validation {
    condition     = var.number_of_broker_nodes > 0
    error_message = "resource_aws_msk_cluster, number_of_broker_nodes must be greater than 0."
  }
}

variable "broker_node_group_info" {
  description = "Configuration block for the broker nodes of the Kafka cluster"
  type = object({
    client_subnets  = list(string)
    instance_type   = string
    security_groups = list(string)
    az_distribution = optional(string, "DEFAULT")
    connectivity_info = optional(object({
      public_access = optional(object({
        type = optional(string)
      }))
      vpc_connectivity = optional(object({
        client_authentication = optional(object({
          tls = optional(bool)
          sasl = optional(object({
            iam   = optional(bool)
            scram = optional(bool)
          }))
        }))
      }))
    }))
    storage_info = optional(object({
      ebs_storage_info = optional(object({
        volume_size = optional(number)
        provisioned_throughput = optional(object({
          enabled           = optional(bool, false)
          volume_throughput = optional(number)
        }))
      }))
    }))
  })

  validation {
    condition     = length(var.broker_node_group_info.client_subnets) > 0
    error_message = "resource_aws_msk_cluster, broker_node_group_info.client_subnets must contain at least one subnet."
  }

  validation {
    condition     = var.broker_node_group_info.instance_type != ""
    error_message = "resource_aws_msk_cluster, broker_node_group_info.instance_type cannot be empty."
  }

  validation {
    condition     = length(var.broker_node_group_info.security_groups) > 0
    error_message = "resource_aws_msk_cluster, broker_node_group_info.security_groups must contain at least one security group."
  }

  validation {
    condition     = var.broker_node_group_info.az_distribution == null || contains(["DEFAULT"], var.broker_node_group_info.az_distribution)
    error_message = "resource_aws_msk_cluster, broker_node_group_info.az_distribution must be 'DEFAULT' when specified."
  }

  validation {
    condition = (
      var.broker_node_group_info.connectivity_info == null ||
      var.broker_node_group_info.connectivity_info.public_access == null ||
      var.broker_node_group_info.connectivity_info.public_access.type == null ||
      contains(["DISABLED", "SERVICE_PROVIDED_EIPS"], var.broker_node_group_info.connectivity_info.public_access.type)
    )
    error_message = "resource_aws_msk_cluster, broker_node_group_info.connectivity_info.public_access.type must be 'DISABLED' or 'SERVICE_PROVIDED_EIPS'."
  }

  validation {
    condition = (
      var.broker_node_group_info.storage_info == null ||
      var.broker_node_group_info.storage_info.ebs_storage_info == null ||
      var.broker_node_group_info.storage_info.ebs_storage_info.volume_size == null ||
      (var.broker_node_group_info.storage_info.ebs_storage_info.volume_size >= 1 && var.broker_node_group_info.storage_info.ebs_storage_info.volume_size <= 16384)
    )
    error_message = "resource_aws_msk_cluster, broker_node_group_info.storage_info.ebs_storage_info.volume_size must be between 1 and 16384 GiB."
  }

  validation {
    condition = (
      var.broker_node_group_info.storage_info == null ||
      var.broker_node_group_info.storage_info.ebs_storage_info == null ||
      var.broker_node_group_info.storage_info.ebs_storage_info.provisioned_throughput == null ||
      var.broker_node_group_info.storage_info.ebs_storage_info.provisioned_throughput.volume_throughput == null ||
      var.broker_node_group_info.storage_info.ebs_storage_info.provisioned_throughput.volume_throughput >= 250
    )
    error_message = "resource_aws_msk_cluster, broker_node_group_info.storage_info.ebs_storage_info.provisioned_throughput.volume_throughput must be at least 250 MiB per second."
  }
}

variable "client_authentication" {
  description = "Configuration block for specifying a client authentication"
  type = object({
    unauthenticated = optional(bool)
    sasl = optional(object({
      iam   = optional(bool, false)
      scram = optional(bool, false)
    }))
    tls = optional(object({
      certificate_authority_arns = optional(list(string))
    }))
  })
  default = null
}

variable "configuration_info" {
  description = "Configuration block for specifying an MSK Configuration to attach to Kafka brokers"
  type = object({
    arn      = string
    revision = number
  })
  default = null

  validation {
    condition = (
      var.configuration_info == null ||
      (var.configuration_info.arn != "" && var.configuration_info.revision > 0)
    )
    error_message = "resource_aws_msk_cluster, configuration_info.arn cannot be empty and configuration_info.revision must be greater than 0."
  }
}

variable "encryption_info" {
  description = "Configuration block for specifying encryption"
  type = object({
    encryption_at_rest_kms_key_arn = optional(string)
    encryption_in_transit = optional(object({
      client_broker = optional(string, "TLS")
      in_cluster    = optional(bool, true)
    }))
  })
  default = null

  validation {
    condition = (
      var.encryption_info == null ||
      var.encryption_info.encryption_in_transit == null ||
      var.encryption_info.encryption_in_transit.client_broker == null ||
      contains(["TLS", "TLS_PLAINTEXT", "PLAINTEXT"], var.encryption_info.encryption_in_transit.client_broker)
    )
    error_message = "resource_aws_msk_cluster, encryption_info.encryption_in_transit.client_broker must be 'TLS', 'TLS_PLAINTEXT', or 'PLAINTEXT'."
  }
}

variable "enhanced_monitoring" {
  description = "Specify the desired enhanced MSK CloudWatch monitoring level"
  type        = string
  default     = null
}

variable "open_monitoring" {
  description = "Configuration block for JMX and Node monitoring for the MSK cluster"
  type = object({
    prometheus = object({
      jmx_exporter = optional(object({
        enabled_in_broker = bool
      }))
      node_exporter = optional(object({
        enabled_in_broker = bool
      }))
    })
  })
  default = null
}

variable "logging_info" {
  description = "Configuration block for streaming broker logs to Cloudwatch/S3/Kinesis Firehose"
  type = object({
    broker_logs = object({
      cloudwatch_logs = optional(object({
        enabled   = optional(bool)
        log_group = optional(string)
      }))
      firehose = optional(object({
        enabled         = optional(bool)
        delivery_stream = optional(string)
      }))
      s3 = optional(object({
        enabled = optional(bool)
        bucket  = optional(string)
        prefix  = optional(string)
      }))
    })
  })
  default = null
}

variable "storage_mode" {
  description = "Controls storage mode for supported storage tiers. Valid values are: LOCAL or TIERED"
  type        = string
  default     = null

  validation {
    condition = (
      var.storage_mode == null ||
      contains(["LOCAL", "TIERED"], var.storage_mode)
    )
    error_message = "resource_aws_msk_cluster, storage_mode must be 'LOCAL' or 'TIERED'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}