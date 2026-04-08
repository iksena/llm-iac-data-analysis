variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A unique name for this Environment. This name is used in the application URL"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*$", var.name)) && length(var.name) >= 1 && length(var.name) <= 40
    error_message = "resource_aws_elastic_beanstalk_environment, name must be 1-40 characters long, start with a letter, and contain only alphanumeric characters and hyphens."
  }
}

variable "application" {
  description = "Name of the application that contains the version to be deployed"
  type        = string

  validation {
    condition     = length(var.application) > 0
    error_message = "resource_aws_elastic_beanstalk_environment, application cannot be empty."
  }
}

variable "cname_prefix" {
  description = "Prefix to use for the fully qualified DNS name of the Environment"
  type        = string
  default     = null

  validation {
    condition     = var.cname_prefix == null || can(regex("^[a-z][a-z0-9-]*$", var.cname_prefix))
    error_message = "resource_aws_elastic_beanstalk_environment, cname_prefix must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "description" {
  description = "Short description of the Environment"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 200
    error_message = "resource_aws_elastic_beanstalk_environment, description cannot exceed 200 characters."
  }
}

variable "tier" {
  description = "Elastic Beanstalk Environment tier. Valid values are Worker or WebServer. If tier is left blank WebServer will be used."
  type        = string
  default     = "WebServer"

  validation {
    condition     = contains(["Worker", "WebServer"], var.tier)
    error_message = "resource_aws_elastic_beanstalk_environment, tier must be either 'Worker' or 'WebServer'."
  }
}

variable "solution_stack_name" {
  description = "A solution stack to base your environment off of. Example stacks can be found in the Amazon API documentation"
  type        = string
  default     = null

  validation {
    condition     = var.solution_stack_name == null || length(var.solution_stack_name) > 0
    error_message = "resource_aws_elastic_beanstalk_environment, solution_stack_name cannot be empty if provided."
  }
}

variable "template_name" {
  description = "The name of the Elastic Beanstalk Configuration template to use in deployment"
  type        = string
  default     = null

  validation {
    condition     = var.template_name == null || length(var.template_name) > 0
    error_message = "resource_aws_elastic_beanstalk_environment, template_name cannot be empty if provided."
  }
}

variable "platform_arn" {
  description = "The ARN of the Elastic Beanstalk Platform to use in deployment"
  type        = string
  default     = null

  validation {
    condition     = var.platform_arn == null || can(regex("^arn:aws:elasticbeanstalk:", var.platform_arn))
    error_message = "resource_aws_elastic_beanstalk_environment, platform_arn must be a valid Elastic Beanstalk platform ARN."
  }
}

variable "wait_for_ready_timeout" {
  description = "The maximum duration that Terraform should wait for an Elastic Beanstalk Environment to be in a ready state before timing out"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.wait_for_ready_timeout))
    error_message = "resource_aws_elastic_beanstalk_environment, wait_for_ready_timeout must be a valid duration format (e.g., '20m', '1h', '30s')."
  }
}

variable "poll_interval" {
  description = "The time between polling the AWS API to check if changes have been applied. Use this to adjust the rate of API calls for any create or update action. Minimum 10s, maximum 180s."
  type        = string
  default     = null

  validation {
    condition = var.poll_interval == null || (
      can(regex("^[0-9]+s$", var.poll_interval)) &&
      tonumber(regex("[0-9]+", var.poll_interval)) >= 10 &&
      tonumber(regex("[0-9]+", var.poll_interval)) <= 180
    )
    error_message = "resource_aws_elastic_beanstalk_environment, poll_interval must be between 10s and 180s."
  }
}

variable "version_label" {
  description = "The name of the Elastic Beanstalk Application Version to use in deployment"
  type        = string
  default     = null

  validation {
    condition     = var.version_label == null || length(var.version_label) > 0
    error_message = "resource_aws_elastic_beanstalk_environment, version_label cannot be empty if provided."
  }
}

variable "tags" {
  description = "A set of tags to apply to the Environment"
  type        = map(string)
  default     = {}

  validation {
    condition     = length(var.tags) <= 50
    error_message = "resource_aws_elastic_beanstalk_environment, tags cannot exceed 50 key-value pairs."
  }
}

variable "settings" {
  description = "Option settings to configure the new Environment. These override specific values that are set as defaults"
  type = list(object({
    namespace = string
    name      = string
    value     = string
    resource  = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for setting in var.settings :
      length(setting.namespace) > 0 && length(setting.name) > 0 && length(setting.value) > 0
    ])
    error_message = "resource_aws_elastic_beanstalk_environment, settings must have non-empty namespace, name, and value fields."
  }
}