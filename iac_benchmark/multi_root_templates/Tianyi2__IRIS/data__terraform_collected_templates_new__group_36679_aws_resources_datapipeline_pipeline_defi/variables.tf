variable "pipeline_id" {
  description = "ID of the pipeline"
  type        = string

  validation {
    condition     = length(var.pipeline_id) > 0
    error_message = "resource_aws_datapipeline_pipeline_definition, pipeline_id must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "pipeline_object" {
  description = "Configuration block for the objects that define the pipeline"
  type = list(object({
    id   = string
    name = string
    field = list(object({
      key          = string
      ref_value    = optional(string)
      string_value = optional(string)
    }))
  }))

  validation {
    condition     = length(var.pipeline_object) > 0
    error_message = "resource_aws_datapipeline_pipeline_definition, pipeline_object must contain at least one object."
  }

  validation {
    condition = alltrue([
      for obj in var.pipeline_object : length(obj.id) > 0
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, pipeline_object id must not be empty."
  }

  validation {
    condition = alltrue([
      for obj in var.pipeline_object : length(obj.name) > 0
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, pipeline_object name must not be empty."
  }

  validation {
    condition = alltrue([
      for obj in var.pipeline_object : length(obj.field) > 0
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, pipeline_object field must contain at least one field."
  }

  validation {
    condition = alltrue([
      for obj in var.pipeline_object : alltrue([
        for field in obj.field : length(field.key) > 0
      ])
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, pipeline_object field key must not be empty."
  }

  validation {
    condition = alltrue([
      for obj in var.pipeline_object : alltrue([
        for field in obj.field : field.ref_value != null || field.string_value != null
      ])
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, pipeline_object field must have either ref_value or string_value specified."
  }
}

variable "parameter_object" {
  description = "Configuration block for the parameter objects used in the pipeline definition"
  type = list(object({
    id = string
    attribute = list(object({
      key          = string
      string_value = string
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for obj in var.parameter_object : length(obj.id) > 0
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, parameter_object id must not be empty."
  }

  validation {
    condition = alltrue([
      for obj in var.parameter_object : length(obj.attribute) > 0
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, parameter_object attribute must contain at least one attribute."
  }

  validation {
    condition = alltrue([
      for obj in var.parameter_object : alltrue([
        for attr in obj.attribute : length(attr.key) > 0
      ])
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, parameter_object attribute key must not be empty."
  }

  validation {
    condition = alltrue([
      for obj in var.parameter_object : alltrue([
        for attr in obj.attribute : length(attr.string_value) > 0
      ])
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, parameter_object attribute string_value must not be empty."
  }
}

variable "parameter_value" {
  description = "Configuration block for the parameter values used in the pipeline definition"
  type = list(object({
    id           = string
    string_value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for val in var.parameter_value : length(val.id) > 0
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, parameter_value id must not be empty."
  }

  validation {
    condition = alltrue([
      for val in var.parameter_value : length(val.string_value) > 0
    ])
    error_message = "resource_aws_datapipeline_pipeline_definition, parameter_value string_value must not be empty."
  }
}