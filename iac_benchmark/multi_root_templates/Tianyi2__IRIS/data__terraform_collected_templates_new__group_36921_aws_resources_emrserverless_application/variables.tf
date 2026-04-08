variable "name" {
  description = "The name of the application"
  type        = string
}

variable "release_label" {
  description = "The EMR release version associated with the application"
  type        = string
}

variable "type" {
  description = "The type of application you want to start, such as spark or hive"
  type        = string
  validation {
    condition     = contains(["spark", "hive"], var.type)
    error_message = "resource_aws_emrserverless_application, type must be either 'spark' or 'hive'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "architecture" {
  description = "The CPU architecture of an application"
  type        = string
  default     = "X86_64"
  validation {
    condition     = contains(["ARM64", "X86_64"], var.architecture)
    error_message = "resource_aws_emrserverless_application, architecture must be either 'ARM64' or 'X86_64'."
  }
}

variable "auto_start_configuration" {
  description = "The configuration for an application to automatically start on job submission"
  type = object({
    enabled = optional(bool, true)
  })
  default = null
}

variable "auto_stop_configuration" {
  description = "The configuration for an application to automatically stop after a certain amount of time being idle"
  type = object({
    enabled              = optional(bool, true)
    idle_timeout_minutes = optional(number, 15)
  })
  default = null
}

variable "image_configuration" {
  description = "The image configuration applied to all worker types"
  type = object({
    image_uri = string
  })
  default = null
}

variable "initial_capacity" {
  description = "The capacity to initialize when the application is created"
  type = list(object({
    initial_capacity_type = string
    initial_capacity_config = optional(object({
      worker_count = number
      worker_configuration = optional(object({
        cpu    = string
        memory = string
        disk   = optional(string)
      }))
    }))
  }))
  default = null
  validation {
    condition = var.initial_capacity == null ? true : alltrue([
      for ic in var.initial_capacity : contains(["Driver", "Executor", "HiveDriver", "TezTask"], ic.initial_capacity_type)
    ])
    error_message = "resource_aws_emrserverless_application, initial_capacity_type must be one of 'Driver', 'Executor', 'HiveDriver', or 'TezTask'."
  }
}

variable "interactive_configuration" {
  description = "Enables the interactive use cases to use when running an application"
  type = object({
    livy_endpoint_enabled = optional(bool)
    studio_enabled        = optional(bool)
  })
  default = null
}

variable "maximum_capacity" {
  description = "The maximum capacity to allocate when the application is created"
  type = object({
    cpu    = string
    memory = string
    disk   = optional(string)
  })
  default = null
}

variable "network_configuration" {
  description = "The network configuration for customer VPC connectivity"
  type = object({
    security_group_ids = optional(list(string))
    subnet_ids         = optional(list(string))
  })
  default = null
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}