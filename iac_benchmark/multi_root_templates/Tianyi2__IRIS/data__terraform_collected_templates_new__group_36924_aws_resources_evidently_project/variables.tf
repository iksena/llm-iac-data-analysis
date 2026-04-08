variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A name for the project."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_evidently_project, name must not be empty."
  }
}

variable "description" {
  description = "Specifies the description of the project."
  type        = string
  default     = null
}

variable "data_delivery" {
  description = "A block that contains information about where Evidently is to store evaluation events for longer term storage."
  type = object({
    cloudwatch_logs = optional(object({
      log_group = optional(string)
    }))
    s3_destination = optional(object({
      bucket = optional(string)
      prefix = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.data_delivery == null || (
      (var.data_delivery.cloudwatch_logs != null && var.data_delivery.s3_destination == null) ||
      (var.data_delivery.cloudwatch_logs == null && var.data_delivery.s3_destination != null) ||
      (var.data_delivery.cloudwatch_logs == null && var.data_delivery.s3_destination == null)
    )
    error_message = "resource_aws_evidently_project, data_delivery cannot specify both cloudwatch_logs and s3_destination."
  }
}

variable "tags" {
  description = "Tags to apply to the project."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
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