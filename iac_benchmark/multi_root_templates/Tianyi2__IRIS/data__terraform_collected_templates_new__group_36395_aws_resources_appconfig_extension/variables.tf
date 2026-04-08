variable "name" {
  description = "A name for the extension. Each extension name in your account must be unique. Extension versions use the same name."
  type        = string
}

variable "description" {
  description = "Information about the extension."
  type        = string
  default     = null
}

variable "action_point" {
  description = "The action points defined in the extension."
  type = list(object({
    point = string
    action = list(object({
      name        = string
      uri         = string
      role_arn    = optional(string)
      description = optional(string)
    }))
  }))

  validation {
    condition = alltrue([
      for ap in var.action_point : contains([
        "PRE_CREATE_HOSTED_CONFIGURATION_VERSION",
        "PRE_START_DEPLOYMENT",
        "ON_DEPLOYMENT_START",
        "ON_DEPLOYMENT_STEP",
        "ON_DEPLOYMENT_BAKING",
        "ON_DEPLOYMENT_COMPLETE",
        "ON_DEPLOYMENT_ROLLED_BACK"
      ], ap.point)
    ])
    error_message = "resource_aws_appconfig_extension, action_point.point must be one of: PRE_CREATE_HOSTED_CONFIGURATION_VERSION, PRE_START_DEPLOYMENT, ON_DEPLOYMENT_START, ON_DEPLOYMENT_STEP, ON_DEPLOYMENT_BAKING, ON_DEPLOYMENT_COMPLETE, ON_DEPLOYMENT_ROLLED_BACK."
  }

  validation {
    condition = alltrue([
      for ap in var.action_point : length(ap.action) > 0
    ])
    error_message = "resource_aws_appconfig_extension, action_point.action must contain at least one action."
  }

  validation {
    condition = alltrue([
      for ap in var.action_point : alltrue([
        for action in ap.action : action.name != "" && action.uri != ""
      ])
    ])
    error_message = "resource_aws_appconfig_extension, action_point.action.name and action_point.action.uri are required and cannot be empty."
  }
}

variable "parameter" {
  description = "The parameters accepted by the extension. You specify parameter values when you associate the extension to an AppConfig resource by using the CreateExtensionAssociation API action."
  type = list(object({
    name        = string
    required    = bool
    description = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.parameter : param.name != ""
    ])
    error_message = "resource_aws_appconfig_extension, parameter.name is required and cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}