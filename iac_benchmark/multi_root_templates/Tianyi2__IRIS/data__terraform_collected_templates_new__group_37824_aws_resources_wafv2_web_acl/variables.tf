variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "association_config" {
  description = "Specifies custom configurations for the associations between the web ACL and protected resources."
  type = object({
    request_body = optional(object({
      api_gateway = optional(object({
        default_size_inspection_limit = string
      }))
      app_runner_service = optional(object({
        default_size_inspection_limit = string
      }))
      cloudfront = optional(object({
        default_size_inspection_limit = string
      }))
      cognito_user_pool = optional(object({
        default_size_inspection_limit = string
      }))
      verified_access_instance = optional(object({
        default_size_inspection_limit = string
      }))
    }))
  })
  default = null

  validation {
    condition = var.association_config == null || (
      var.association_config.request_body == null || (
        (var.association_config.request_body.api_gateway == null || contains(["KB_16", "KB_32", "KB_48", "KB_64"], var.association_config.request_body.api_gateway.default_size_inspection_limit)) &&
        (var.association_config.request_body.app_runner_service == null || contains(["KB_16", "KB_32", "KB_48", "KB_64"], var.association_config.request_body.app_runner_service.default_size_inspection_limit)) &&
        (var.association_config.request_body.cloudfront == null || contains(["KB_16", "KB_32", "KB_48", "KB_64"], var.association_config.request_body.cloudfront.default_size_inspection_limit)) &&
        (var.association_config.request_body.cognito_user_pool == null || contains(["KB_16", "KB_32", "KB_48", "KB_64"], var.association_config.request_body.cognito_user_pool.default_size_inspection_limit)) &&
        (var.association_config.request_body.verified_access_instance == null || contains(["KB_16", "KB_32", "KB_48", "KB_64"], var.association_config.request_body.verified_access_instance.default_size_inspection_limit))
      )
    )
    error_message = "resource_aws_wafv2_web_acl, association_config: default_size_inspection_limit must be one of: KB_16, KB_32, KB_48, KB_64."
  }
}

variable "captcha_config" {
  description = "Specifies how AWS WAF should handle CAPTCHA evaluations on the ACL level (used by AWS Bot Control)."
  type = object({
    immunity_time_property = optional(object({
      immunity_time = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.captcha_config == null || (
      var.captcha_config.immunity_time_property == null ||
      var.captcha_config.immunity_time_property.immunity_time == null ||
      var.captcha_config.immunity_time_property.immunity_time >= 0
    )
    error_message = "resource_aws_wafv2_web_acl, captcha_config: immunity_time must be non-negative."
  }
}

variable "challenge_config" {
  description = "Specifies how AWS WAF should handle Challenge evaluations on the ACL level (used by AWS Bot Control)."
  type = object({
    immunity_time_property = optional(object({
      immunity_time = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.challenge_config == null || (
      var.challenge_config.immunity_time_property == null ||
      var.challenge_config.immunity_time_property.immunity_time == null ||
      var.challenge_config.immunity_time_property.immunity_time >= 0
    )
    error_message = "resource_aws_wafv2_web_acl, challenge_config: immunity_time must be non-negative."
  }
}

variable "custom_response_body" {
  description = "Defines custom response bodies that can be referenced by custom_response actions."
  type = list(object({
    key          = string
    content      = string
    content_type = string
  }))
  default = []

  validation {
    condition = alltrue([
      for crb in var.custom_response_body : contains(["TEXT_PLAIN", "TEXT_HTML", "APPLICATION_JSON"], crb.content_type)
    ])
    error_message = "resource_aws_wafv2_web_acl, custom_response_body: content_type must be one of: TEXT_PLAIN, TEXT_HTML, APPLICATION_JSON."
  }
}

variable "data_protection_config" {
  description = "Specifies data protection to apply to the web request data for the web ACL."
  type = object({
    data_protection = list(object({
      action = string
      field = object({
        field_type = string
        field_keys = optional(list(string))
      })
      exclude_rate_based_details = optional(bool)
      exclude_rule_match_details = optional(bool)
    }))
  })
  default = null

  validation {
    condition = var.data_protection_config == null || alltrue([
      for dp in var.data_protection_config.data_protection : contains(["SUBSTITUTION", "HASH"], dp.action)
    ])
    error_message = "resource_aws_wafv2_web_acl, data_protection_config: action must be one of: SUBSTITUTION, HASH."
  }

  validation {
    condition = var.data_protection_config == null || alltrue([
      for dp in var.data_protection_config.data_protection : contains(["SINGLE_HEADER", "SINGLE_COOKIE", "SINGLE_QUERY_ARGUMENT", "QUERY_STRING", "BODY"], dp.field.field_type)
    ])
    error_message = "resource_aws_wafv2_web_acl, data_protection_config: field_type must be one of: SINGLE_HEADER, SINGLE_COOKIE, SINGLE_QUERY_ARGUMENT, QUERY_STRING, BODY."
  }
}

variable "default_action" {
  description = "Action to perform if none of the rules contained in the WebACL match."
  type = object({
    allow = optional(object({
      custom_request_handling = optional(object({
        insert_header = list(object({
          name  = string
          value = string
        }))
      }))
    }))
    block = optional(object({
      custom_response = optional(object({
        custom_response_body_key = optional(string)
        response_code            = number
        response_header = optional(list(object({
          name  = string
          value = string
        })))
      }))
    }))
  })

  validation {
    condition     = (var.default_action.allow != null) != (var.default_action.block != null)
    error_message = "resource_aws_wafv2_web_acl, default_action: exactly one of allow or block must be specified."
  }

  validation {
    condition = var.default_action.block == null || var.default_action.block.custom_response == null || (
      var.default_action.block.custom_response.response_code >= 200 &&
      var.default_action.block.custom_response.response_code <= 599
    )
    error_message = "resource_aws_wafv2_web_acl, default_action: response_code must be between 200 and 599."
  }
}

variable "description" {
  description = "Friendly description of the WebACL."
  type        = string
  default     = null
}

variable "name" {
  description = "Friendly name of the WebACL. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null

  validation {
    condition     = !(var.name != null && var.name_prefix != null)
    error_message = "resource_aws_wafv2_web_acl, name_prefix: name and name_prefix cannot both be specified."
  }
}

variable "rule" {
  description = "Rule blocks used to identify the web requests that you want to allow, block, or count."
  type = list(object({
    action = optional(object({
      allow = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
      block = optional(object({
        custom_response = optional(object({
          custom_response_body_key = optional(string)
          response_code            = number
          response_header = optional(list(object({
            name  = string
            value = string
          })))
        }))
      }))
      captcha = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
      challenge = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
      count = optional(object({
        custom_request_handling = optional(object({
          insert_header = list(object({
            name  = string
            value = string
          }))
        }))
      }))
    }))
    captcha_config = optional(object({
      immunity_time_property = optional(object({
        immunity_time = optional(number)
      }))
    }))
    challenge_config = optional(object({
      immunity_time_property = optional(object({
        immunity_time = optional(number)
      }))
    }))
    name = string
    override_action = optional(object({
      count = optional(object({}))
      none  = optional(object({}))
    }))
    priority = number
    rule_label = optional(list(object({
      name = string
    })))
    statement = any # Complex nested structure - using any for simplicity
    visibility_config = object({
      cloudwatch_metrics_enabled = bool
      metric_name                = string
      sampled_requests_enabled   = bool
    })
  }))
  default = []

  validation {
    condition = alltrue([
      for r in var.rule : (r.action != null) != (r.override_action != null)
    ])
    error_message = "resource_aws_wafv2_web_acl, rule: exactly one of action or override_action must be specified for each rule."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.override_action == null || (r.override_action.count != null) != (r.override_action.none != null)
    ])
    error_message = "resource_aws_wafv2_web_acl, rule: exactly one of count or none must be specified in override_action."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.action == null || (
        sum([
          r.action.allow != null ? 1 : 0,
          r.action.block != null ? 1 : 0,
          r.action.captcha != null ? 1 : 0,
          r.action.challenge != null ? 1 : 0,
          r.action.count != null ? 1 : 0
        ]) == 1
      )
    ])
    error_message = "resource_aws_wafv2_web_acl, rule: exactly one action type (allow, block, captcha, challenge, count) must be specified."
  }

  validation {
    condition = alltrue([
      for r in var.rule : r.priority >= 0
    ])
    error_message = "resource_aws_wafv2_web_acl, rule: priority must be non-negative."
  }

  validation {
    condition = alltrue([
      for r in var.rule : can(regex("^[a-zA-Z0-9-_]+$", r.visibility_config.metric_name)) &&
      length(r.visibility_config.metric_name) >= 1 &&
      length(r.visibility_config.metric_name) <= 128
    ])
    error_message = "resource_aws_wafv2_web_acl, rule: metric_name must be 1-128 characters and contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "rule_json" {
  description = "Raw JSON string to allow more than three nested statements. Conflicts with rule attribute."
  type        = string
  default     = null

  validation {
    condition     = !(var.rule != null && var.rule_json != null) || (length(var.rule) == 0 && var.rule_json != null) || (var.rule != null && var.rule_json == null)
    error_message = "resource_aws_wafv2_web_acl, rule_json: rule and rule_json cannot both be specified."
  }
}

variable "scope" {
  description = "Specifies whether this is for an AWS CloudFront distribution or for a regional application."
  type        = string

  validation {
    condition     = contains(["CLOUDFRONT", "REGIONAL"], var.scope)
    error_message = "resource_aws_wafv2_web_acl, scope: must be either CLOUDFRONT or REGIONAL."
  }
}

variable "tags" {
  description = "Map of key-value pairs to associate with the resource."
  type        = map(string)
  default     = {}
}

variable "token_domains" {
  description = "Specifies the domains that AWS WAF should accept in a web request token."
  type        = list(string)
  default     = []
}

variable "visibility_config" {
  description = "Defines and enables Amazon CloudWatch metrics and web request sample collection."
  type = object({
    cloudwatch_metrics_enabled = bool
    metric_name                = string
    sampled_requests_enabled   = bool
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.visibility_config.metric_name)) && length(var.visibility_config.metric_name) >= 1 && length(var.visibility_config.metric_name) <= 128
    error_message = "resource_aws_wafv2_web_acl, visibility_config: metric_name must be 1-128 characters and contain only alphanumeric characters, hyphens, and underscores."
  }
}