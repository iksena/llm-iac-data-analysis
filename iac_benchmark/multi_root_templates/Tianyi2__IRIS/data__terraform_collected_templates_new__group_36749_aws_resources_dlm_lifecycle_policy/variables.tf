variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}

variable "description" {
  description = "A description for the DLM lifecycle policy."
  type        = string

  validation {
    condition     = length(var.description) > 0
    error_message = "resource_aws_dlm_lifecycle_policy, description must not be empty."
  }
}

variable "execution_role_arn" {
  description = "The ARN of an IAM role that is able to be assumed by the DLM service."
  type        = string

  validation {
    condition     = length(var.execution_role_arn) > 0
    error_message = "resource_aws_dlm_lifecycle_policy, execution_role_arn must not be empty."
  }
}

variable "default_policy" {
  description = "Specify the type of default policy to create. valid values are VOLUME or INSTANCE."
  type        = string
  default     = null

  validation {
    condition     = var.default_policy == null || contains(["VOLUME", "INSTANCE"], var.default_policy)
    error_message = "resource_aws_dlm_lifecycle_policy, default_policy must be VOLUME or INSTANCE."
  }
}

variable "state" {
  description = "Whether the lifecycle policy should be enabled or disabled. ENABLED or DISABLED are valid values."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.state)
    error_message = "resource_aws_dlm_lifecycle_policy, state must be ENABLED or DISABLED."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "policy_details" {
  description = "Configuration block for policy details."
  type = object({
    copy_tags          = optional(bool)
    create_interval    = optional(number)
    extend_deletion    = optional(bool)
    retain_interval    = optional(number)
    resource_type      = optional(string)
    resource_types     = optional(list(string))
    resource_locations = optional(list(string))
    policy_language    = optional(string)
    policy_type        = optional(string)
    target_tags        = optional(map(string))

    action = optional(object({
      name = optional(string)
      cross_region_copy = optional(object({
        target = string
        encryption_configuration = object({
          cmk_arn   = optional(string)
          encrypted = bool
        })
        retain_rule = object({
          interval      = number
          interval_unit = string
        })
      }))
    }))

    event_source = optional(object({
      type = string
      parameters = object({
        description_regex = string
        event_type        = string
        snapshot_owner    = list(string)
      })
    }))

    exclusions = optional(object({
      exclude_boot_volumes = optional(bool)
      exclude_tags         = optional(map(string))
      exclude_volume_types = optional(list(string))
    }))

    parameters = optional(object({
      exclude_boot_volume = optional(bool)
      no_reboot           = optional(bool)
    }))

    schedule = optional(list(object({
      name          = string
      copy_tags     = optional(bool)
      tags_to_add   = optional(map(string))
      variable_tags = optional(map(string))

      archive_rule = optional(object({
        archive_retain_rule = object({
          retention_archive_tier = object({
            count         = optional(number)
            interval      = optional(number)
            interval_unit = optional(string)
          })
        })
      }))

      create_rule = object({
        cron_expression = optional(string)
        interval        = optional(number)
        interval_unit   = optional(string)
        location        = optional(string)
        times           = optional(list(string))

        scripts = optional(object({
          execute_operation_on_script_failure = optional(bool)
          execution_handler                   = string
          execution_handler_service           = optional(string)
          execution_timeout                   = optional(number)
          maximum_retry_count                 = optional(number)
          stages                              = optional(list(string))
        }))
      })

      cross_region_copy_rule = optional(list(object({
        cmk_arn       = optional(string)
        copy_tags     = optional(bool)
        encrypted     = bool
        target        = optional(string)
        target_region = optional(string)

        deprecate_rule = optional(object({
          interval      = number
          interval_unit = string
        }))

        retain_rule = object({
          interval      = number
          interval_unit = string
        })
      })))

      deprecate_rule = optional(object({
        count         = optional(number)
        interval      = optional(number)
        interval_unit = optional(string)
      }))

      fast_restore_rule = optional(object({
        availability_zones = list(string)
        count              = optional(number)
        interval           = optional(number)
        interval_unit      = optional(string)
      }))

      retain_rule = object({
        count         = optional(number)
        interval      = optional(number)
        interval_unit = optional(string)
      })

      share_rule = optional(object({
        target_accounts       = list(string)
        unshare_interval      = optional(number)
        unshare_interval_unit = optional(string)
      }))
    })))
  })
  default = null

  validation {
    condition = var.policy_details == null || (
      var.policy_details.create_interval == null ||
      (var.policy_details.create_interval >= 1 && var.policy_details.create_interval <= 7)
    )
    error_message = "resource_aws_dlm_lifecycle_policy, create_interval must be between 1 and 7."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.retain_interval == null ||
      (var.policy_details.retain_interval >= 2 && var.policy_details.retain_interval <= 14)
    )
    error_message = "resource_aws_dlm_lifecycle_policy, retain_interval must be between 2 and 14."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.resource_type == null ||
      contains(["VOLUME", "INSTANCE"], var.policy_details.resource_type)
    )
    error_message = "resource_aws_dlm_lifecycle_policy, resource_type must be VOLUME or INSTANCE."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.resource_types == null ||
      alltrue([for rt in var.policy_details.resource_types : contains(["VOLUME", "INSTANCE"], rt)])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, resource_types must contain only VOLUME or INSTANCE values."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.resource_locations == null ||
      alltrue([for rl in var.policy_details.resource_locations : contains(["CLOUD", "LOCAL_ZONE", "OUTPOST"], rl)])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, resource_locations must contain only CLOUD, LOCAL_ZONE, or OUTPOST values."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.policy_language == null ||
      contains(["SIMPLIFIED", "STANDARD"], var.policy_details.policy_language)
    )
    error_message = "resource_aws_dlm_lifecycle_policy, policy_language must be SIMPLIFIED or STANDARD."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.policy_type == null ||
      contains(["EBS_SNAPSHOT_MANAGEMENT", "IMAGE_MANAGEMENT", "EVENT_BASED_POLICY"], var.policy_details.policy_type)
    )
    error_message = "resource_aws_dlm_lifecycle_policy, policy_type must be EBS_SNAPSHOT_MANAGEMENT, IMAGE_MANAGEMENT, or EVENT_BASED_POLICY."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.event_source == null ||
      contains(["MANAGED_CWE"], var.policy_details.event_source.type)
    )
    error_message = "resource_aws_dlm_lifecycle_policy, event_source type must be MANAGED_CWE."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.event_source == null ||
      var.policy_details.event_source.parameters == null ||
      contains(["shareSnapshot"], var.policy_details.event_source.parameters.event_type)
    )
    error_message = "resource_aws_dlm_lifecycle_policy, event_source parameters event_type must be shareSnapshot."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.create_rule.interval == null ||
        contains([1, 2, 3, 4, 6, 8, 12, 24], s.create_rule.interval)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule create_rule interval must be 1, 2, 3, 4, 6, 8, 12, or 24."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.create_rule.interval_unit == null ||
        contains(["HOURS"], s.create_rule.interval_unit)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule create_rule interval_unit must be HOURS."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.create_rule.location == null ||
        contains(["CLOUD", "OUTPOST_LOCAL"], s.create_rule.location)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule create_rule location must be CLOUD or OUTPOST_LOCAL."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.create_rule.scripts == null ||
        s.create_rule.scripts.maximum_retry_count == null ||
        (s.create_rule.scripts.maximum_retry_count >= 0 && s.create_rule.scripts.maximum_retry_count <= 3)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule create_rule scripts maximum_retry_count must be between 0 and 3."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.create_rule.scripts == null ||
        s.create_rule.scripts.stages == null ||
        alltrue([for stage in s.create_rule.scripts.stages : contains(["PRE", "POST"], stage)])
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule create_rule scripts stages must contain only PRE or POST values."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.deprecate_rule == null ||
        s.deprecate_rule.count == null ||
        (s.deprecate_rule.count >= 1 && s.deprecate_rule.count <= 1000)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule deprecate_rule count must be between 1 and 1000."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.deprecate_rule == null ||
        s.deprecate_rule.interval_unit == null ||
        contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], s.deprecate_rule.interval_unit)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule deprecate_rule interval_unit must be DAYS, WEEKS, MONTHS, or YEARS."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.fast_restore_rule == null ||
        s.fast_restore_rule.count == null ||
        (s.fast_restore_rule.count >= 1 && s.fast_restore_rule.count <= 1000)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule fast_restore_rule count must be between 1 and 1000."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.fast_restore_rule == null ||
        s.fast_restore_rule.interval_unit == null ||
        contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], s.fast_restore_rule.interval_unit)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule fast_restore_rule interval_unit must be DAYS, WEEKS, MONTHS, or YEARS."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.retain_rule.count == null ||
        (s.retain_rule.count >= 1 && s.retain_rule.count <= 1000)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule retain_rule count must be between 1 and 1000."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.retain_rule.interval_unit == null ||
        contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], s.retain_rule.interval_unit)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule retain_rule interval_unit must be DAYS, WEEKS, MONTHS, or YEARS."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.share_rule == null ||
        s.share_rule.unshare_interval_unit == null ||
        contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], s.share_rule.unshare_interval_unit)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule share_rule unshare_interval_unit must be DAYS, WEEKS, MONTHS, or YEARS."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.cross_region_copy_rule == null ||
        alltrue([for crcr in s.cross_region_copy_rule :
          crcr.deprecate_rule == null ||
          crcr.deprecate_rule.interval_unit == null ||
          contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], crcr.deprecate_rule.interval_unit)
        ])
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule cross_region_copy_rule deprecate_rule interval_unit must be DAYS, WEEKS, MONTHS, or YEARS."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.cross_region_copy_rule == null ||
        alltrue([for crcr in s.cross_region_copy_rule :
          crcr.retain_rule.interval_unit == null ||
          contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], crcr.retain_rule.interval_unit)
        ])
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule cross_region_copy_rule retain_rule interval_unit must be DAYS, WEEKS, MONTHS, or YEARS."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.archive_rule == null ||
        s.archive_rule.archive_retain_rule == null ||
        s.archive_rule.archive_retain_rule.retention_archive_tier == null ||
        s.archive_rule.archive_retain_rule.retention_archive_tier.count == null ||
        (s.archive_rule.archive_retain_rule.retention_archive_tier.count >= 1 &&
        s.archive_rule.archive_retain_rule.retention_archive_tier.count <= 1000)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule archive_rule archive_retain_rule retention_archive_tier count must be between 1 and 1000."
  }

  validation {
    condition = var.policy_details == null || (
      var.policy_details.schedule == null ||
      alltrue([for s in var.policy_details.schedule :
        s.archive_rule == null ||
        s.archive_rule.archive_retain_rule == null ||
        s.archive_rule.archive_retain_rule.retention_archive_tier == null ||
        s.archive_rule.archive_retain_rule.retention_archive_tier.interval_unit == null ||
        contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], s.archive_rule.archive_retain_rule.retention_archive_tier.interval_unit)
      ])
    )
    error_message = "resource_aws_dlm_lifecycle_policy, schedule archive_rule archive_retain_rule retention_archive_tier interval_unit must be DAYS, WEEKS, MONTHS, or YEARS."
  }
}