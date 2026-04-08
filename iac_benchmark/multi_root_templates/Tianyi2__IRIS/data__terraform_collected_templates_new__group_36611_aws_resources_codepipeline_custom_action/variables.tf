variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "category" {
  description = "The category of the custom action."
  type        = string
  validation {
    condition     = contains(["Source", "Build", "Deploy", "Test", "Invoke", "Approval"], var.category)
    error_message = "resource_aws_codepipeline_custom_action_type, category must be one of: Source, Build, Deploy, Test, Invoke, Approval."
  }
}

variable "configuration_property" {
  description = "The configuration properties for the custom action. Max 10 items."
  type = list(object({
    description = optional(string)
    key         = bool
    name        = string
    queryable   = optional(bool)
    required    = bool
    secret      = bool
    type        = optional(string)
  }))
  default = null
  validation {
    condition     = var.configuration_property == null || length(var.configuration_property) <= 10
    error_message = "resource_aws_codepipeline_custom_action_type, configuration_property can have a maximum of 10 items."
  }
  validation {
    condition = var.configuration_property == null || alltrue([
      for prop in var.configuration_property :
      prop.type == null || contains(["String", "Number", "Boolean"], prop.type)
    ])
    error_message = "resource_aws_codepipeline_custom_action_type, configuration_property type must be one of: String, Number, Boolean."
  }
}

variable "input_artifact_details" {
  description = "The details of the input artifact for the action."
  type = object({
    maximum_count = number
    minimum_count = number
  })
  validation {
    condition     = var.input_artifact_details.maximum_count >= 0 && var.input_artifact_details.maximum_count <= 5
    error_message = "resource_aws_codepipeline_custom_action_type, input_artifact_details maximum_count must be between 0 and 5."
  }
  validation {
    condition     = var.input_artifact_details.minimum_count >= 0 && var.input_artifact_details.minimum_count <= 5
    error_message = "resource_aws_codepipeline_custom_action_type, input_artifact_details minimum_count must be between 0 and 5."
  }
}

variable "output_artifact_details" {
  description = "The details of the output artifact of the action."
  type = object({
    maximum_count = number
    minimum_count = number
  })
  validation {
    condition     = var.output_artifact_details.maximum_count >= 0 && var.output_artifact_details.maximum_count <= 5
    error_message = "resource_aws_codepipeline_custom_action_type, output_artifact_details maximum_count must be between 0 and 5."
  }
  validation {
    condition     = var.output_artifact_details.minimum_count >= 0 && var.output_artifact_details.minimum_count <= 5
    error_message = "resource_aws_codepipeline_custom_action_type, output_artifact_details minimum_count must be between 0 and 5."
  }
}

variable "provider_name" {
  description = "The provider of the service used in the custom action."
  type        = string
}

variable "settings" {
  description = "The settings for an action type."
  type = object({
    entity_url_template           = optional(string)
    execution_url_template        = optional(string)
    revision_url_template         = optional(string)
    third_party_configuration_url = optional(string)
  })
  default = null
}

variable "tags" {
  description = "Map of tags to assign to this resource."
  type        = map(string)
  default     = {}
}

variable "action_version" {
  description = "The version identifier of the custom action."
  type        = string
}