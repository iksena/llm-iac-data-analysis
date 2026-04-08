variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.instance_id))
    error_message = "resource_aws_connect_quick_connect, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "Specifies the name of the Quick Connect"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 127
    error_message = "resource_aws_connect_quick_connect, name must be between 1 and 127 characters."
  }
}

variable "description" {
  description = "Specifies the description of the Quick Connect"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || (length(var.description) <= 250)
    error_message = "resource_aws_connect_quick_connect, description must be 250 characters or less."
  }
}

variable "quick_connect_config" {
  description = "A block that defines the configuration information for the Quick Connect"
  type = object({
    quick_connect_type = string
    phone_config = optional(object({
      phone_number = string
    }))
    queue_config = optional(object({
      contact_flow_id = string
      queue_id        = string
    }))
    user_config = optional(object({
      contact_flow_id = string
      user_id         = string
    }))
  })

  validation {
    condition     = contains(["PHONE_NUMBER", "QUEUE", "USER"], var.quick_connect_config.quick_connect_type)
    error_message = "resource_aws_connect_quick_connect, quick_connect_type must be one of: PHONE_NUMBER, QUEUE, USER."
  }

  validation {
    condition = (
      var.quick_connect_config.quick_connect_type == "PHONE_NUMBER" && var.quick_connect_config.phone_config != null
      ) || (
      var.quick_connect_config.quick_connect_type == "QUEUE" && var.quick_connect_config.queue_config != null
      ) || (
      var.quick_connect_config.quick_connect_type == "USER" && var.quick_connect_config.user_config != null
    )
    error_message = "resource_aws_connect_quick_connect, quick_connect_config must have corresponding config block for the specified quick_connect_type."
  }

  validation {
    condition = var.quick_connect_config.phone_config == null || (
      var.quick_connect_config.phone_config != null &&
      can(regex("^\\+[1-9]\\d{1,14}$", var.quick_connect_config.phone_config.phone_number))
    )
    error_message = "resource_aws_connect_quick_connect, phone_number must be in E.164 format."
  }

  validation {
    condition = var.quick_connect_config.queue_config == null || (
      var.quick_connect_config.queue_config != null &&
      can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.quick_connect_config.queue_config.contact_flow_id))
    )
    error_message = "resource_aws_connect_quick_connect, contact_flow_id must be a valid UUID format."
  }

  validation {
    condition = var.quick_connect_config.queue_config == null || (
      var.quick_connect_config.queue_config != null &&
      can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.quick_connect_config.queue_config.queue_id))
    )
    error_message = "resource_aws_connect_quick_connect, queue_id must be a valid UUID format."
  }

  validation {
    condition = var.quick_connect_config.user_config == null || (
      var.quick_connect_config.user_config != null &&
      can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.quick_connect_config.user_config.contact_flow_id))
    )
    error_message = "resource_aws_connect_quick_connect, contact_flow_id must be a valid UUID format."
  }

  validation {
    condition = var.quick_connect_config.user_config == null || (
      var.quick_connect_config.user_config != null &&
      can(regex("^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.quick_connect_config.user_config.user_id))
    )
    error_message = "resource_aws_connect_quick_connect, user_id must be a valid UUID format."
  }
}

variable "tags" {
  description = "Tags to apply to the Quick Connect"
  type        = map(string)
  default     = null
}