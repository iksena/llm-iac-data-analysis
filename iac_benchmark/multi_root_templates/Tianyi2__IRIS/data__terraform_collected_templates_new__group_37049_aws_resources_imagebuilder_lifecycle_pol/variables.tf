variable "name" {
  description = "The name of the lifecycle policy to create."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_imagebuilder_lifecycle_policy, name must not be empty."
  }
}

variable "resource_type" {
  description = "The type of Image Builder resource that the lifecycle policy applies to. Valid values: AMI_IMAGE or CONTAINER_IMAGE."
  type        = string

  validation {
    condition     = contains(["AMI_IMAGE", "CONTAINER_IMAGE"], var.resource_type)
    error_message = "resource_aws_imagebuilder_lifecycle_policy, resource_type must be either AMI_IMAGE or CONTAINER_IMAGE."
  }
}

variable "execution_role" {
  description = "The Amazon Resource Name (ARN) for the IAM role you create that grants Image Builder access to run lifecycle actions."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.execution_role))
    error_message = "resource_aws_imagebuilder_lifecycle_policy, execution_role must be a valid IAM role ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description for the lifecycle policy."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags for the Image Builder Lifecycle Policy."
  type        = map(string)
  default     = {}
}

variable "policy_detail" {
  description = "Configuration block with policy details."
  type = object({
    region = optional(string)
    action = object({
      type   = string
      region = optional(string)
      include_resources = optional(object({
        region     = optional(string)
        amis       = optional(bool)
        containers = optional(bool)
        snapshots  = optional(bool)
      }))
    })
    filter = object({
      type            = string
      value           = number
      region          = optional(string)
      retain_at_least = optional(number)
      unit            = optional(string)
    })
    exclusion_rules = optional(object({
      region  = optional(string)
      tag_map = optional(map(string))
      amis = optional(object({
        region          = optional(string)
        is_public       = optional(bool)
        regions         = optional(list(string))
        shared_accounts = optional(list(string))
        tag_map         = optional(map(string))
        last_launched = optional(object({
          unit  = string
          value = number
        }))
      }))
    }))
  })

  validation {
    condition     = contains(["DELETE", "DEPRECATE", "DISABLE"], var.policy_detail.action.type)
    error_message = "resource_aws_imagebuilder_lifecycle_policy, policy_detail.action.type must be DELETE, DEPRECATE, or DISABLE."
  }

  validation {
    condition     = contains(["AGE", "COUNT"], var.policy_detail.filter.type)
    error_message = "resource_aws_imagebuilder_lifecycle_policy, policy_detail.filter.type must be AGE or COUNT."
  }

  validation {
    condition     = var.policy_detail.filter.unit == null || contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], var.policy_detail.filter.unit)
    error_message = "resource_aws_imagebuilder_lifecycle_policy, policy_detail.filter.unit must be DAYS, WEEKS, MONTHS, or YEARS when specified."
  }

  validation {
    condition     = var.policy_detail.exclusion_rules == null || var.policy_detail.exclusion_rules.amis == null || var.policy_detail.exclusion_rules.amis.last_launched == null || contains(["DAYS", "WEEKS", "MONTHS", "YEARS"], var.policy_detail.exclusion_rules.amis.last_launched.unit)
    error_message = "resource_aws_imagebuilder_lifecycle_policy, policy_detail.exclusion_rules.amis.last_launched.unit must be DAYS, WEEKS, MONTHS, or YEARS when specified."
  }

  validation {
    condition     = var.policy_detail.filter.value > 0
    error_message = "resource_aws_imagebuilder_lifecycle_policy, policy_detail.filter.value must be greater than 0."
  }

  validation {
    condition     = var.policy_detail.exclusion_rules == null || var.policy_detail.exclusion_rules.amis == null || var.policy_detail.exclusion_rules.amis.last_launched == null || var.policy_detail.exclusion_rules.amis.last_launched.value > 0
    error_message = "resource_aws_imagebuilder_lifecycle_policy, policy_detail.exclusion_rules.amis.last_launched.value must be greater than 0 when specified."
  }

  validation {
    condition     = var.policy_detail.filter.retain_at_least == null || var.policy_detail.filter.retain_at_least >= 0
    error_message = "resource_aws_imagebuilder_lifecycle_policy, policy_detail.filter.retain_at_least must be greater than or equal to 0 when specified."
  }
}

variable "resource_selection" {
  description = "Selection criteria for the resources that the lifecycle policy applies to."
  type = object({
    region  = optional(string)
    tag_map = optional(map(string))
    recipe = optional(list(object({
      name             = string
      semantic_version = string
    })))
  })

  validation {
    condition = var.resource_selection.recipe == null || alltrue([
      for r in var.resource_selection.recipe : length(r.name) > 0 && length(r.semantic_version) > 0
    ])
    error_message = "resource_aws_imagebuilder_lifecycle_policy, resource_selection.recipe name and semantic_version must not be empty when specified."
  }
}