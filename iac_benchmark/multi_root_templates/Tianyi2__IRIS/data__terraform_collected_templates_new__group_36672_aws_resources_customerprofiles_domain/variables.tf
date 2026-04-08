variable "domain_name" {
  description = "The name for your Customer Profile domain. It must be unique for your AWS account."
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_customerprofiles_domain, domain_name must not be empty."
  }
}

variable "default_expiration_days" {
  description = "The default number of days until the data within the domain expires."
  type        = number

  validation {
    condition     = var.default_expiration_days > 0
    error_message = "resource_aws_customerprofiles_domain, default_expiration_days must be greater than 0."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "dead_letter_queue_url" {
  description = "The URL of the SQS dead letter queue, which is used for reporting errors associated with ingesting data from third party applications."
  type        = string
  default     = null
}

variable "default_encryption_key" {
  description = "The default encryption key, which is an AWS managed key, is used when no specific type of encryption key is specified."
  type        = string
  default     = null
}

variable "matching" {
  description = "A block that specifies the process of matching duplicate profiles."
  type = object({
    enabled = bool
    auto_merging = optional(object({
      enabled = bool
      conflict_resolution = optional(object({
        conflict_resolving_model = string
        source_name              = optional(string)
      }))
      consolidation = optional(object({
        matching_attributes_list = list(list(string))
      }))
      min_allowed_confidence_score_for_merging = optional(number)
    }))
    exporting_config = optional(object({
      s3_exporting_config = optional(object({
        s3_bucket_name = string
        s3_key_name    = optional(string)
      }))
    }))
    job_schedule = optional(object({
      day_of_the_week = string
      time            = string
    }))
  })
  default = null

  validation {
    condition = var.matching == null || (
      contains(["RECENCY", "SOURCE"], try(var.matching.auto_merging.conflict_resolution.conflict_resolving_model, "RECENCY"))
    )
    error_message = "resource_aws_customerprofiles_domain, matching.auto_merging.conflict_resolution.conflict_resolving_model must be either 'RECENCY' or 'SOURCE'."
  }

  validation {
    condition = var.matching == null || (
      var.matching.auto_merging == null ||
      var.matching.auto_merging.min_allowed_confidence_score_for_merging == null ||
      (var.matching.auto_merging.min_allowed_confidence_score_for_merging >= 0 && var.matching.auto_merging.min_allowed_confidence_score_for_merging <= 1)
    )
    error_message = "resource_aws_customerprofiles_domain, matching.auto_merging.min_allowed_confidence_score_for_merging must be between 0 and 1."
  }
}

variable "rule_based_matching" {
  description = "A block that specifies the process of matching duplicate profiles using the Rule-Based matching."
  type = object({
    enabled = bool
    attribute_types_selector = optional(object({
      attribute_matching_model = string
      address                  = optional(list(string))
      email_address            = optional(list(string))
      phone_number             = optional(list(string))
    }))
    conflict_resolution = optional(object({
      conflict_resolving_model = string
      source_name              = optional(string)
    }))
    exporting_config = optional(object({
      s3_exporting_config = optional(object({
        s3_bucket_name = string
        s3_key_name    = optional(string)
      }))
    }))
    matching_rules = optional(object({
      rule = list(string)
    }))
    max_allowed_rule_level_for_matching = optional(number)
    max_allowed_rule_level_for_merging  = optional(number)
  })
  default = null

  validation {
    condition = var.rule_based_matching == null || (
      contains(["ONE_TO_ONE", "MANY_TO_MANY"], try(var.rule_based_matching.attribute_types_selector.attribute_matching_model, "ONE_TO_ONE"))
    )
    error_message = "resource_aws_customerprofiles_domain, rule_based_matching.attribute_types_selector.attribute_matching_model must be either 'ONE_TO_ONE' or 'MANY_TO_MANY'."
  }

  validation {
    condition = var.rule_based_matching == null || (
      contains(["RECENCY", "SOURCE"], try(var.rule_based_matching.conflict_resolution.conflict_resolving_model, "RECENCY"))
    )
    error_message = "resource_aws_customerprofiles_domain, rule_based_matching.conflict_resolution.conflict_resolving_model must be either 'RECENCY' or 'SOURCE'."
  }

  validation {
    condition = var.rule_based_matching == null || (
      var.rule_based_matching.attribute_types_selector == null ||
      var.rule_based_matching.attribute_types_selector.address == null ||
      alltrue([for addr in var.rule_based_matching.attribute_types_selector.address : contains(["Address", "BusinessAddress", "MaillingAddress", "ShippingAddress"], addr)])
    )
    error_message = "resource_aws_customerprofiles_domain, rule_based_matching.attribute_types_selector.address values must be one of: Address, BusinessAddress, MaillingAddress, ShippingAddress."
  }

  validation {
    condition = var.rule_based_matching == null || (
      var.rule_based_matching.attribute_types_selector == null ||
      var.rule_based_matching.attribute_types_selector.email_address == null ||
      alltrue([for email in var.rule_based_matching.attribute_types_selector.email_address : contains(["EmailAddress", "BusinessEmailAddress", "PersonalEmailAddress"], email)])
    )
    error_message = "resource_aws_customerprofiles_domain, rule_based_matching.attribute_types_selector.email_address values must be one of: EmailAddress, BusinessEmailAddress, PersonalEmailAddress."
  }

  validation {
    condition = var.rule_based_matching == null || (
      var.rule_based_matching.attribute_types_selector == null ||
      var.rule_based_matching.attribute_types_selector.phone_number == null ||
      alltrue([for phone in var.rule_based_matching.attribute_types_selector.phone_number : contains(["PhoneNumber", "HomePhoneNumber", "MobilePhoneNumber"], phone)])
    )
    error_message = "resource_aws_customerprofiles_domain, rule_based_matching.attribute_types_selector.phone_number values must be one of: PhoneNumber, HomePhoneNumber, MobilePhoneNumber."
  }

  validation {
    condition = var.rule_based_matching == null || (
      var.rule_based_matching.matching_rules == null ||
      length(var.rule_based_matching.matching_rules.rule) <= 15
    )
    error_message = "resource_aws_customerprofiles_domain, rule_based_matching.matching_rules.rule can have up to 15 rules."
  }
}

variable "tags" {
  description = "Tags to apply to the domain."
  type        = map(string)
  default     = {}
}