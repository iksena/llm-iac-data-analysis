variable "domain_name" {
  type        = string
  description = "Name of the domain"

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9-]*$", var.domain_name)) && length(var.domain_name) >= 3 && length(var.domain_name) <= 28
    error_message = "resource_aws_opensearch_domain, domain_name must be between 3 and 28 characters, start with a lowercase letter or number, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed"
  default     = null
}

variable "access_policies" {
  type        = string
  description = "IAM policy document specifying the access policies for the domain"
  default     = null
}

variable "advanced_options" {
  type        = map(string)
  description = "Key-value string pairs to specify advanced configuration options"
  default     = null
}

variable "engine_version" {
  type        = string
  description = "Either Elasticsearch_X.Y or OpenSearch_X.Y to specify the engine version for the Amazon OpenSearch Service domain"
  default     = null

  validation {
    condition     = var.engine_version == null || can(regex("^(Elasticsearch|OpenSearch)_[0-9]+\\.[0-9]+$", var.engine_version))
    error_message = "resource_aws_opensearch_domain, engine_version must be in the format 'Elasticsearch_X.Y' or 'OpenSearch_X.Y' (e.g., 'OpenSearch_1.0' or 'Elasticsearch_7.9')."
  }
}

variable "ip_address_type" {
  type        = string
  description = "The IP address type for the endpoint"
  default     = null

  validation {
    condition     = var.ip_address_type == null || contains(["ipv4", "dualstack"], var.ip_address_type)
    error_message = "resource_aws_opensearch_domain, ip_address_type must be either 'ipv4' or 'dualstack'."
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource"
  default     = null
}

variable "advanced_security_options" {
  type = object({
    anonymous_auth_enabled         = optional(bool)
    enabled                        = bool
    internal_user_database_enabled = optional(bool, false)
    master_user_options = optional(object({
      master_user_arn      = optional(string)
      master_user_name     = optional(string)
      master_user_password = optional(string)
    }))
  })
  description = "Configuration block for fine-grained access control"
  default     = null
}

variable "auto_tune_options" {
  type = object({
    desired_state       = string
    rollback_on_disable = optional(string)
    use_off_peak_window = optional(bool, false)
    maintenance_schedule = optional(list(object({
      start_at                       = string
      cron_expression_for_recurrence = string
      duration = object({
        value = number
        unit  = string
      })
    })))
  })
  description = "Configuration block for the Auto-Tune options of the domain"
  default     = null

  validation {
    condition     = var.auto_tune_options == null || contains(["ENABLED", "DISABLED"], var.auto_tune_options.desired_state)
    error_message = "resource_aws_opensearch_domain, auto_tune_options desired_state must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.auto_tune_options == null || var.auto_tune_options.rollback_on_disable == null || contains(["DEFAULT_ROLLBACK", "NO_ROLLBACK"], var.auto_tune_options.rollback_on_disable)
    error_message = "resource_aws_opensearch_domain, auto_tune_options rollback_on_disable must be either 'DEFAULT_ROLLBACK' or 'NO_ROLLBACK'."
  }
}

variable "cluster_config" {
  type = object({
    dedicated_master_count        = optional(number)
    dedicated_master_enabled      = optional(bool)
    dedicated_master_type         = optional(string)
    instance_count                = optional(number)
    instance_type                 = optional(string)
    multi_az_with_standby_enabled = optional(bool)
    warm_count                    = optional(number)
    warm_enabled                  = optional(bool)
    warm_type                     = optional(string)
    zone_awareness_enabled        = optional(bool)
    cold_storage_options = optional(object({
      enabled = optional(bool, false)
    }))
    node_options = optional(list(object({
      node_type = optional(string)
      node_config = optional(object({
        count   = optional(number)
        enabled = optional(bool)
        type    = optional(string)
      }))
    })))
    zone_awareness_config = optional(object({
      availability_zone_count = optional(number, 2)
    }))
  })
  description = "Configuration block for the cluster of the domain"
  default     = null

  validation {
    condition     = var.cluster_config == null || var.cluster_config.warm_count == null || (var.cluster_config.warm_count >= 2 && var.cluster_config.warm_count <= 150)
    error_message = "resource_aws_opensearch_domain, cluster_config warm_count must be between 2 and 150."
  }

  validation {
    condition     = var.cluster_config == null || var.cluster_config.warm_type == null || contains(["ultrawarm1.medium.search", "ultrawarm1.large.search", "ultrawarm1.xlarge.search"], var.cluster_config.warm_type)
    error_message = "resource_aws_opensearch_domain, cluster_config warm_type must be one of 'ultrawarm1.medium.search', 'ultrawarm1.large.search', or 'ultrawarm1.xlarge.search'."
  }

  validation {
    condition     = var.cluster_config == null || var.cluster_config.zone_awareness_config == null || contains([2, 3], var.cluster_config.zone_awareness_config.availability_zone_count)
    error_message = "resource_aws_opensearch_domain, cluster_config zone_awareness_config availability_zone_count must be either 2 or 3."
  }

  validation {
    condition = var.cluster_config == null || var.cluster_config.node_options == null || alltrue([
      for node in var.cluster_config.node_options : node.node_type == null || contains(["coordinator"], node.node_type)
    ])
    error_message = "resource_aws_opensearch_domain, cluster_config node_options node_type must be 'coordinator'."
  }
}

variable "cognito_options" {
  type = object({
    enabled          = optional(bool, false)
    identity_pool_id = string
    role_arn         = string
    user_pool_id     = string
  })
  description = "Configuration block for authenticating dashboard with Cognito"
  default     = null
}

variable "domain_endpoint_options" {
  type = object({
    custom_endpoint_certificate_arn = optional(string)
    custom_endpoint_enabled         = optional(bool)
    custom_endpoint                 = optional(string)
    enforce_https                   = optional(bool, true)
    tls_security_policy             = optional(string)
  })
  description = "Configuration block for domain endpoint HTTP(S) related options"
  default     = null
}

variable "ebs_options" {
  type = object({
    ebs_enabled = bool
    iops        = optional(number)
    throughput  = optional(number)
    volume_size = optional(number)
    volume_type = optional(string)
  })
  description = "Configuration block for EBS related options"
  default     = null

  validation {
    condition     = var.ebs_options == null || !var.ebs_options.ebs_enabled || var.ebs_options.volume_size != null
    error_message = "resource_aws_opensearch_domain, ebs_options volume_size is required when ebs_enabled is true."
  }

  validation {
    condition     = var.ebs_options == null || var.ebs_options.volume_type != "gp3" || var.ebs_options.throughput != null
    error_message = "resource_aws_opensearch_domain, ebs_options throughput is required when volume_type is 'gp3'."
  }
}

variable "encrypt_at_rest" {
  type = object({
    enabled    = bool
    kms_key_id = optional(string)
  })
  description = "Configuration block for encrypt at rest options"
  default     = null
}

variable "log_publishing_options" {
  type = list(object({
    cloudwatch_log_group_arn = string
    enabled                  = optional(bool, true)
    log_type                 = string
  }))
  description = "Configuration block for publishing slow and application logs to CloudWatch Logs"
  default     = null

  validation {
    condition = var.log_publishing_options == null || alltrue([
      for log in var.log_publishing_options : contains(["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS", "ES_APPLICATION_LOGS", "AUDIT_LOGS"], log.log_type)
    ])
    error_message = "resource_aws_opensearch_domain, log_publishing_options log_type must be one of 'INDEX_SLOW_LOGS', 'SEARCH_SLOW_LOGS', 'ES_APPLICATION_LOGS', or 'AUDIT_LOGS'."
  }
}

variable "node_to_node_encryption" {
  type = object({
    enabled = bool
  })
  description = "Configuration block for node-to-node encryption options"
  default     = null
}

variable "snapshot_options" {
  type = object({
    automated_snapshot_start_hour = number
  })
  description = "Configuration block for snapshot related options"
  default     = null

  validation {
    condition     = var.snapshot_options == null || (var.snapshot_options.automated_snapshot_start_hour >= 0 && var.snapshot_options.automated_snapshot_start_hour <= 23)
    error_message = "resource_aws_opensearch_domain, snapshot_options automated_snapshot_start_hour must be between 0 and 23."
  }
}

variable "software_update_options" {
  type = object({
    auto_software_update_enabled = optional(bool, false)
  })
  description = "Software update options for the domain"
  default     = null
}

variable "vpc_options" {
  type = object({
    security_group_ids = optional(list(string))
    subnet_ids         = list(string)
  })
  description = "Configuration block for VPC related options"
  default     = null
}

variable "off_peak_window_options" {
  type = object({
    enabled = optional(bool)
    off_peak_window = optional(object({
      window_start_time = optional(object({
        hours   = number
        minutes = number
      }))
    }))
  })
  description = "Configuration to add Off Peak update options"
  default     = null

  validation {
    condition = var.off_peak_window_options == null || var.off_peak_window_options.off_peak_window == null || var.off_peak_window_options.off_peak_window.window_start_time == null || (
      var.off_peak_window_options.off_peak_window.window_start_time.hours >= 0 &&
      var.off_peak_window_options.off_peak_window.window_start_time.hours <= 23 &&
      var.off_peak_window_options.off_peak_window.window_start_time.minutes >= 0 &&
      var.off_peak_window_options.off_peak_window.window_start_time.minutes <= 59
    )
    error_message = "resource_aws_opensearch_domain, off_peak_window_options window_start_time hours must be between 0 and 23, and minutes must be between 0 and 59."
  }
}

variable "timeouts" {
  type = object({
    create = optional(string, "90m")
    update = optional(string, "180m")
    delete = optional(string, "90m")
  })
  description = "Configuration options for timeouts"
  default = {
    create = "90m"
    update = "180m"
    delete = "90m"
  }
}