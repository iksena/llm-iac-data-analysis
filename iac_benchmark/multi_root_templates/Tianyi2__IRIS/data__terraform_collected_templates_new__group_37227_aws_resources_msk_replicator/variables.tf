variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "replicator_name" {
  description = "The name of the replicator."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.replicator_name))
    error_message = "resource_aws_msk_replicator, replicator_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "service_execution_role_arn" {
  description = "The ARN of the IAM role used by the replicator to access resources in the customer's account (e.g source and target clusters)."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.service_execution_role_arn))
    error_message = "resource_aws_msk_replicator, service_execution_role_arn must be a valid IAM role ARN."
  }
}

variable "description" {
  description = "A summary description of the replicator."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "kafka_cluster" {
  description = "A list of Kafka clusters which are targets of the replicator."
  type = list(object({
    amazon_msk_cluster = list(object({
      msk_cluster_arn = string
    }))
    vpc_config = list(object({
      subnet_ids          = list(string)
      security_groups_ids = list(string)
    }))
  }))

  validation {
    condition     = length(var.kafka_cluster) >= 1
    error_message = "resource_aws_msk_replicator, kafka_cluster must contain at least one cluster configuration."
  }

  validation {
    condition = alltrue([
      for cluster in var.kafka_cluster : can(regex("^arn:aws:kafka:[a-z0-9-]+:[0-9]{12}:cluster/.+", cluster.amazon_msk_cluster[0].msk_cluster_arn))
    ])
    error_message = "resource_aws_msk_replicator, kafka_cluster amazon_msk_cluster msk_cluster_arn must be a valid MSK cluster ARN."
  }

  validation {
    condition = alltrue([
      for cluster in var.kafka_cluster : length(cluster.vpc_config[0].subnet_ids) >= 1
    ])
    error_message = "resource_aws_msk_replicator, kafka_cluster vpc_config subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition = alltrue([
      for cluster in var.kafka_cluster : length(cluster.vpc_config[0].security_groups_ids) >= 1
    ])
    error_message = "resource_aws_msk_replicator, kafka_cluster vpc_config security_groups_ids must contain at least one security group ID."
  }
}

variable "replication_info_list" {
  description = "A list of replication configurations, where each configuration targets a given source cluster to target cluster replication flow."
  type = list(object({
    source_kafka_cluster_arn = string
    target_kafka_cluster_arn = string
    target_compression_type  = string
    topic_replication = list(object({
      topics_to_replicate                  = list(string)
      topics_to_exclude                    = optional(list(string))
      detect_and_copy_new_topics           = optional(bool)
      copy_access_control_lists_for_topics = optional(bool)
      copy_topic_configurations            = optional(bool)
      topic_name_configuration = optional(object({
        type = string
      }))
      starting_position = optional(object({
        type = string
      }))
    }))
    consumer_group_replication = list(object({
      consumer_groups_to_replicate        = list(string)
      consumer_groups_to_exclude          = optional(list(string))
      detect_and_copy_new_consumer_groups = optional(bool)
      synchronise_consumer_group_offsets  = optional(bool)
    }))
  }))

  validation {
    condition     = length(var.replication_info_list) >= 1
    error_message = "resource_aws_msk_replicator, replication_info_list must contain at least one replication configuration."
  }

  validation {
    condition = alltrue([
      for repl in var.replication_info_list : can(regex("^arn:aws:kafka:[a-z0-9-]+:[0-9]{12}:cluster/.+", repl.source_kafka_cluster_arn))
    ])
    error_message = "resource_aws_msk_replicator, replication_info_list source_kafka_cluster_arn must be a valid MSK cluster ARN."
  }

  validation {
    condition = alltrue([
      for repl in var.replication_info_list : can(regex("^arn:aws:kafka:[a-z0-9-]+:[0-9]{12}:cluster/.+", repl.target_kafka_cluster_arn))
    ])
    error_message = "resource_aws_msk_replicator, replication_info_list target_kafka_cluster_arn must be a valid MSK cluster ARN."
  }

  validation {
    condition = alltrue([
      for repl in var.replication_info_list : contains(["NONE", "GZIP", "SNAPPY", "LZ4", "ZSTD"], repl.target_compression_type)
    ])
    error_message = "resource_aws_msk_replicator, replication_info_list target_compression_type must be one of: NONE, GZIP, SNAPPY, LZ4, ZSTD."
  }

  validation {
    condition = alltrue([
      for repl in var.replication_info_list : length(repl.topic_replication[0].topics_to_replicate) >= 1
    ])
    error_message = "resource_aws_msk_replicator, replication_info_list topic_replication topics_to_replicate must contain at least one topic pattern."
  }

  validation {
    condition = alltrue([
      for repl in var.replication_info_list : length(repl.consumer_group_replication[0].consumer_groups_to_replicate) >= 1
    ])
    error_message = "resource_aws_msk_replicator, replication_info_list consumer_group_replication consumer_groups_to_replicate must contain at least one consumer group pattern."
  }

  validation {
    condition = alltrue([
      for repl in var.replication_info_list :
      repl.topic_replication[0].topic_name_configuration == null ||
      contains(["PREFIXED_WITH_SOURCE_CLUSTER_ALIAS", "IDENTICAL"], repl.topic_replication[0].topic_name_configuration.type)
    ])
    error_message = "resource_aws_msk_replicator, replication_info_list topic_replication topic_name_configuration type must be one of: PREFIXED_WITH_SOURCE_CLUSTER_ALIAS, IDENTICAL."
  }

  validation {
    condition = alltrue([
      for repl in var.replication_info_list :
      repl.topic_replication[0].starting_position == null ||
      contains(["LATEST", "EARLIEST"], repl.topic_replication[0].starting_position.type)
    ])
    error_message = "resource_aws_msk_replicator, replication_info_list topic_replication starting_position type must be one of: LATEST, EARLIEST."
  }
}

variable "timeouts" {
  description = "Timeout configuration for the resource operations."
  type = object({
    create = optional(string, "60m")
    update = optional(string, "180m")
    delete = optional(string, "90m")
  })
  default = {
    create = "60m"
    update = "180m"
    delete = "90m"
  }

  validation {
    condition = alltrue([
      can(regex("^[0-9]+[smh]$", var.timeouts.create)),
      can(regex("^[0-9]+[smh]$", var.timeouts.update)),
      can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    ])
    error_message = "resource_aws_msk_replicator, timeouts must be valid duration strings (e.g., '60m', '2h', '30s')."
  }
}