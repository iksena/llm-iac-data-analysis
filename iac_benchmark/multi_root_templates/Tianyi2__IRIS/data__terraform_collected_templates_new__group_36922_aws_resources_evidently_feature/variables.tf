variable "name" {
  description = "The name for the new feature"
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 127
    error_message = "resource_aws_evidently_feature, name must be between 1 and 127 characters."
  }
}

variable "project" {
  description = "The name or ARN of the project that is to contain the new feature"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "default_variation" {
  description = "The name of the variation to use as the default variation. The default variation is served to users who are not allocated to any ongoing launches or experiments of this feature"
  type        = string
  default     = null
}

variable "description" {
  description = "Specifies the description of the feature"
  type        = string
  default     = null
}

variable "entity_overrides" {
  description = "Specify users that should always be served a specific variation of a feature. Each user is specified by a key-value pair"
  type        = map(string)
  default     = null
}

variable "evaluation_strategy" {
  description = "Specify ALL_RULES to activate the traffic allocation specified by any ongoing launches or experiments. Specify DEFAULT_VARIATION to serve the default variation to all users instead"
  type        = string
  default     = null

  validation {
    condition     = var.evaluation_strategy == null || contains(["ALL_RULES", "DEFAULT_VARIATION"], var.evaluation_strategy)
    error_message = "resource_aws_evidently_feature, evaluation_strategy must be either 'ALL_RULES' or 'DEFAULT_VARIATION'."
  }
}

variable "tags" {
  description = "Tags to apply to the feature"
  type        = map(string)
  default     = {}
}

variable "variations" {
  description = "One or more blocks that contain the configuration of the feature's different variations"
  type = list(object({
    name = string
    value = object({
      bool_value   = optional(bool)
      double_value = optional(number)
      long_value   = optional(number)
      string_value = optional(string)
    })
  }))

  validation {
    condition = alltrue([
      for variation in var.variations : length(variation.name) >= 1 && length(variation.name) <= 127
    ])
    error_message = "resource_aws_evidently_feature, variations name must be between 1 and 127 characters."
  }

  validation {
    condition = alltrue([
      for variation in var.variations : length(compact([
        variation.value.bool_value != null ? "bool" : null,
        variation.value.double_value != null ? "double" : null,
        variation.value.long_value != null ? "long" : null,
        variation.value.string_value != null ? "string" : null
      ])) == 1
    ])
    error_message = "resource_aws_evidently_feature, variations value must specify exactly one of bool_value, double_value, long_value, or string_value."
  }

  validation {
    condition = alltrue([
      for variation in var.variations : variation.value.long_value == null || (
        variation.value.long_value >= -9007199254740991 && variation.value.long_value <= 9007199254740991
      )
    ])
    error_message = "resource_aws_evidently_feature, variations long_value must be between -9007199254740991 and 9007199254740991."
  }

  validation {
    condition = alltrue([
      for variation in var.variations : variation.value.string_value == null || (
        length(variation.value.string_value) >= 0 && length(variation.value.string_value) <= 512
      )
    ])
    error_message = "resource_aws_evidently_feature, variations string_value must be between 0 and 512 characters."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts"
  type = object({
    create = optional(string, "2m")
    delete = optional(string, "2m")
    update = optional(string, "2m")
  })
  default = {
    create = "2m"
    delete = "2m"
    update = "2m"
  }
}