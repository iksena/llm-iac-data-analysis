variable "name" {
  description = "A unique name for this Template"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_elastic_beanstalk_configuration_template, name must not be empty."
  }
}

variable "application" {
  description = "Name of the application to associate with this configuration template"
  type        = string

  validation {
    condition     = length(var.application) > 0
    error_message = "resource_aws_elastic_beanstalk_configuration_template, application must not be empty."
  }
}

variable "description" {
  description = "Short description of the Template"
  type        = string
  default     = null
}

variable "environment_id" {
  description = "The ID of the environment used with this configuration template"
  type        = string
  default     = null
}

variable "solution_stack_name" {
  description = "A solution stack to base your Template off of"
  type        = string
  default     = null
}

variable "setting" {
  description = "Option settings to configure the new Environment"
  type = list(object({
    namespace = string
    name      = string
    value     = string
    resource  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for s in var.setting : length(s.namespace) > 0
    ])
    error_message = "resource_aws_elastic_beanstalk_configuration_template, setting namespace must not be empty."
  }

  validation {
    condition = alltrue([
      for s in var.setting : length(s.name) > 0
    ])
    error_message = "resource_aws_elastic_beanstalk_configuration_template, setting name must not be empty."
  }

  validation {
    condition = alltrue([
      for s in var.setting : length(s.value) > 0
    ])
    error_message = "resource_aws_elastic_beanstalk_configuration_template, setting value must not be empty."
  }
}