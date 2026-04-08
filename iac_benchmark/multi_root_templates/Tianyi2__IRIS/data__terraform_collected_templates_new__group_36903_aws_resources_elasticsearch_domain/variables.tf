variable "domain_name" {
  description = "Name of the domain."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9\\-]+$", var.domain_name)) && length(var.domain_name) >= 3 && length(var.domain_name) <= 28
    error_message = "resource_aws_elasticsearch_domain, domain_name must be between 3 and 28 characters long and contain only lowercase letters, numbers, and hyphens. Must start with a letter."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "access_policies" {
  description = "IAM policy document specifying the access policies for the domain."
  type        = string
  default     = null
}

variable "advanced_options" {
  description = "Key-value string pairs to specify advanced configuration options."
  type        = map(string)
  default     = null
}

variable "advanced_security_options" {
  description = "Configuration block for fine-grained access control."
  type = object({
    enabled                        = bool
    internal_user_database_enabled = optional(bool, false)
    master_user_options = optional(object({
      master_user_arn      = optional(string)
      master_user_name     = optional(string)
      master_user_password = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.advanced_security_options == null || (
      var.advanced_security_options.internal_user_database_enabled == false && var.advanced_security_options.master_user_options != null ? var.advanced_security_options.master_user_options.master_user_arn != null : true
      ) && (
      var.advanced_security_options.internal_user_database_enabled == true && var.advanced_security_options.master_user_options != null ? (var.advanced_security_options.master_user_options.master_user_name != null && var.advanced_security_options.master_user_options.master_user_password != null) : true
    )
    error_message = "resource_aws_elasticsearch_domain, advanced_security_options when internal_user_database_enabled is false, master_user_arn must be specified; when internal_user_database_enabled is true, master_user_name and master_user_password must be specified."
  }
}

variable "auto_tune_options" {
  description = "Configuration block for the Auto-Tune options of the domain."
  type = object({
    desired_state       = string
    rollback_on_disable = optional(string)
    maintenance_schedule = optional(list(object({
      start_at                       = string
      cron_expression_for_recurrence = string
      duration = object({
        value = number
        unit  = string
      })
    })))
  })
  default = null

  validation {
    condition     = var.auto_tune_options == null || contains(["ENABLED", "DISABLED"], var.auto_tune_options.desired_state)
    error_message = "resource_aws_elasticsearch_domain, auto_tune_options desired_state must be either 'ENABLED' or 'DISABLED'."
  }

  validation {
    condition     = var.auto_tune_options == null || var.auto_tune_options.rollback_on_disable == null || contains(["DEFAULT_ROLLBACK", "NO_ROLLBACK"], var.auto_tune_options.rollback_on_disable)
    error_message = "resource_aws_elasticsearch_domain, auto_tune_options rollback_on_disable must be either 'DEFAULT_ROLLBACK' or 'NO_ROLLBACK'."
  }

  validation {
    condition = var.auto_tune_options == null || var.auto_tune_options.maintenance_schedule == null || alltrue([
      for schedule in var.auto_tune_options.maintenance_schedule : schedule.duration.unit == "HOURS"
    ])
    error_message = "resource_aws_elasticsearch_domain, auto_tune_options maintenance_schedule duration unit must be 'HOURS'."
  }
}

variable "cluster_config" {
  description = "Configuration block for the cluster of the domain."
  type = object({
    dedicated_master_count   = optional(number)
    dedicated_master_enabled = optional(bool)
    dedicated_master_type    = optional(string)
    instance_count           = optional(number)
    instance_type            = optional(string)
    warm_count               = optional(number)
    warm_enabled             = optional(bool)
    warm_type                = optional(string)
    zone_awareness_enabled   = optional(bool)
    cold_storage_options = optional(object({
      enabled = optional(bool, false)
    }))
    zone_awareness_config = optional(object({
      availability_zone_count = optional(number, 2)
    }))
  })
  default = null

  validation {
    condition     = var.cluster_config == null || var.cluster_config.warm_count == null || (var.cluster_config.warm_count >= 2 && var.cluster_config.warm_count <= 150)
    error_message = "resource_aws_elasticsearch_domain, cluster_config warm_count must be between 2 and 150."
  }

  validation {
    condition     = var.cluster_config == null || var.cluster_config.warm_enabled != true || var.cluster_config.warm_count != null
    error_message = "resource_aws_elasticsearch_domain, cluster_config warm_count must be set when warm_enabled is true."
  }

  validation {
    condition     = var.cluster_config == null || var.cluster_config.warm_enabled != true || var.cluster_config.warm_type != null
    error_message = "resource_aws_elasticsearch_domain, cluster_config warm_type must be set when warm_enabled is true."
  }

  validation {
    condition     = var.cluster_config == null || var.cluster_config.warm_type == null || contains(["ultrawarm1.medium.elasticsearch", "ultrawarm1.large.elasticsearch", "ultrawarm1.xlarge.elasticsearch"], var.cluster_config.warm_type)
    error_message = "resource_aws_elasticsearch_domain, cluster_config warm_type must be one of: ultrawarm1.medium.elasticsearch, ultrawarm1.large.elasticsearch, ultrawarm1.xlarge.elasticsearch."
  }

  validation {
    condition     = var.cluster_config == null || var.cluster_config.zone_awareness_config == null || contains([2, 3], var.cluster_config.zone_awareness_config.availability_zone_count)
    error_message = "resource_aws_elasticsearch_domain, cluster_config zone_awareness_config availability_zone_count must be 2 or 3."
  }
}

variable "cognito_options" {
  description = "Configuration block for authenticating Kibana with Cognito."
  type = object({
    enabled          = optional(bool, false)
    identity_pool_id = string
    role_arn         = string
    user_pool_id     = string
  })
  default = null
}

variable "domain_endpoint_options" {
  description = "Configuration block for domain endpoint HTTP(S) related options."
  type = object({
    custom_endpoint_certificate_arn = optional(string)
    custom_endpoint_enabled         = optional(bool)
    custom_endpoint                 = optional(string)
    enforce_https                   = optional(bool, true)
    tls_security_policy             = optional(string)
  })
  default = null

  validation {
    condition     = var.domain_endpoint_options == null || var.domain_endpoint_options.tls_security_policy == null || contains(["Policy-Min-TLS-1-0-2019-07", "Policy-Min-TLS-1-2-2019-07", "Policy-Min-TLS-1-2-PFS-2023-10"], var.domain_endpoint_options.tls_security_policy)
    error_message = "resource_aws_elasticsearch_domain, domain_endpoint_options tls_security_policy must be one of: Policy-Min-TLS-1-0-2019-07, Policy-Min-TLS-1-2-2019-07, Policy-Min-TLS-1-2-PFS-2023-10."
  }
}

variable "ebs_options" {
  description = "Configuration block for EBS related options, may be required based on chosen instance size."
  type = object({
    ebs_enabled = bool
    iops        = optional(number)
    throughput  = optional(number)
    volume_size = optional(number)
    volume_type = optional(string)
  })
  default = null

  validation {
    condition     = var.ebs_options == null || var.ebs_options.ebs_enabled != true || var.ebs_options.volume_size != null
    error_message = "resource_aws_elasticsearch_domain, ebs_options volume_size is required when ebs_enabled is true."
  }

  validation {
    condition     = var.ebs_options == null || var.ebs_options.volume_type != "gp3" || var.ebs_options.throughput != null
    error_message = "resource_aws_elasticsearch_domain, ebs_options throughput is required when volume_type is gp3."
  }
}

variable "elasticsearch_version" {
  description = "Version of Elasticsearch to deploy. Defaults to 1.5."
  type        = string
  default     = "1.5"
}

variable "encrypt_at_rest" {
  description = "Configuration block for encrypt at rest options. Only available for certain instance types."
  type = object({
    enabled    = bool
    kms_key_id = optional(string)
  })
  default = null
}

variable "log_publishing_options" {
  description = "Configuration block for publishing slow and application logs to CloudWatch Logs. This block can be declared multiple times, for each log_type, within the same resource."
  type = list(object({
    cloudwatch_log_group_arn = string
    enabled                  = optional(bool, true)
    log_type                 = string
  }))
  default = null

  validation {
    condition = var.log_publishing_options == null || alltrue([
      for option in var.log_publishing_options : contains(["INDEX_SLOW_LOGS", "SEARCH_SLOW_LOGS", "ES_APPLICATION_LOGS", "AUDIT_LOGS"], option.log_type)
    ])
    error_message = "resource_aws_elasticsearch_domain, log_publishing_options log_type must be one of: INDEX_SLOW_LOGS, SEARCH_SLOW_LOGS, ES_APPLICATION_LOGS, AUDIT_LOGS."
  }
}

variable "node_to_node_encryption" {
  description = "Configuration block for node-to-node encryption options."
  type = object({
    enabled = bool
  })
  default = null
}

variable "snapshot_options" {
  description = "Configuration block for snapshot related options. DEPRECATED. For domains running Elasticsearch 5.3 and later, Amazon ES takes hourly automated snapshots, making this setting irrelevant."
  type = object({
    automated_snapshot_start_hour = number
  })
  default = null

  validation {
    condition     = var.snapshot_options == null || (var.snapshot_options.automated_snapshot_start_hour >= 0 && var.snapshot_options.automated_snapshot_start_hour <= 23)
    error_message = "resource_aws_elasticsearch_domain, snapshot_options automated_snapshot_start_hour must be between 0 and 23."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "vpc_options" {
  description = "Configuration block for VPC related options. Adding or removing this configuration forces a new resource."
  type = object({
    security_group_ids = optional(list(string))
    subnet_ids         = list(string)
  })
  default = null
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "60m")
    update = optional(string, "60m")
    delete = optional(string, "90m")
  })
  default = {
    create = "60m"
    update = "60m"
    delete = "90m"
  }
}