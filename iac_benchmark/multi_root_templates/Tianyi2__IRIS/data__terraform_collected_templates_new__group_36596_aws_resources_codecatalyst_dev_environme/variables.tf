variable "space_name" {
  type        = string
  description = "The name of the space."
}

variable "project_name" {
  type        = string
  description = "The name of the project in the space."
}

variable "instance_type" {
  type        = string
  description = "The Amazon EC2 instace type to use for the Dev Environment."

  validation {
    condition = contains([
      "dev.standard1.small",
      "dev.standard1.medium",
      "dev.standard1.large",
      "dev.standard1.xlarge"
    ], var.instance_type)
    error_message = "resource_aws_codecatalyst_dev_environment, instance_type must be one of: dev.standard1.small, dev.standard1.medium, dev.standard1.large, dev.standard1.xlarge."
  }
}

variable "alias" {
  type        = string
  description = "The alias for the Dev Environment."
  default     = null
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed."
  default     = null
}

variable "inactivity_timeout_minutes" {
  type        = number
  description = "The amount of time the Dev Environment will run without any activity detected before stopping, in minutes."
  default     = null

  validation {
    condition     = var.inactivity_timeout_minutes == null || var.inactivity_timeout_minutes >= 1
    error_message = "resource_aws_codecatalyst_dev_environment, inactivity_timeout_minutes must be a positive integer."
  }
}

variable "persistent_storage" {
  type = list(object({
    size = number
  }))
  description = "Information about the amount of storage allocated to the Dev Environment."

  validation {
    condition     = length(var.persistent_storage) == 1
    error_message = "resource_aws_codecatalyst_dev_environment, persistent_storage must contain exactly one block."
  }

  validation {
    condition     = length(var.persistent_storage) > 0 ? contains([16, 32, 64], var.persistent_storage[0].size) : true
    error_message = "resource_aws_codecatalyst_dev_environment, persistent_storage size must be 16, 32, or 64."
  }
}

variable "ides" {
  type = list(object({
    name    = string
    runtime = optional(string)
  }))
  description = "Information about the integrated development environment (IDE) configured for a Dev Environment."

  validation {
    condition     = length(var.ides) == 1
    error_message = "resource_aws_codecatalyst_dev_environment, ides must contain exactly one block."
  }

  validation {
    condition = length(var.ides) > 0 ? contains([
      "Cloud9",
      "IntelliJ",
      "PyCharm",
      "GoLand",
      "VSCode"
    ], var.ides[0].name) : true
    error_message = "resource_aws_codecatalyst_dev_environment, ides name must be one of: Cloud9, IntelliJ, PyCharm, GoLand, VSCode."
  }
}

variable "repositories" {
  type = list(object({
    repository_name = string
    branch_name     = optional(string)
  }))
  description = "The source repository that contains the branch to clone into the Dev Environment."
  default     = []
}

variable "timeouts" {
  type = object({
    create = optional(string, "30m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  description = "Timeout configuration for resource operations."
  default = {
    create = "30m"
    update = "10m"
    delete = "10m"
  }
}