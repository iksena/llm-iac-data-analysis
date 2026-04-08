variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Selenium testing project."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_devicefarm_test_grid_project, name must not be empty."
  }
}

variable "description" {
  description = "Human-readable description of the project."
  type        = string
  default     = null
}

variable "vpc_config" {
  description = "The VPC security groups and subnets that are attached to a project."
  type = object({
    vpc_id             = string
    subnet_ids         = list(string)
    security_group_ids = list(string)
  })

  validation {
    condition     = length(var.vpc_config.vpc_id) > 0
    error_message = "resource_aws_devicefarm_test_grid_project, vpc_config.vpc_id must not be empty."
  }

  validation {
    condition     = length(var.vpc_config.subnet_ids) > 0
    error_message = "resource_aws_devicefarm_test_grid_project, vpc_config.subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition     = length(var.vpc_config.security_group_ids) > 0
    error_message = "resource_aws_devicefarm_test_grid_project, vpc_config.security_group_ids must contain at least one security group ID."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}