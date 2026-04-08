variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Vault. Names can be between 1 and 255 characters long and the valid characters are a-z, A-Z, 0-9, '_' (underscore), '-' (hyphen), and '.' (period)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]{1,255}$", var.name))
    error_message = "resource_aws_glacier_vault, name must be between 1 and 255 characters long and contain only a-z, A-Z, 0-9, '_', '-', and '.' characters."
  }
}

variable "access_policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string
  default     = null
}

variable "notification" {
  description = "The notifications for the Vault."
  type = object({
    events    = list(string)
    sns_topic = string
  })
  default = null

  validation {
    condition = var.notification == null || (
      var.notification != null &&
      length(var.notification.events) > 0 &&
      alltrue([
        for event in var.notification.events :
        contains(["ArchiveRetrievalCompleted", "InventoryRetrievalCompleted"], event)
      ])
    )
    error_message = "resource_aws_glacier_vault, notification events must be one or both of 'ArchiveRetrievalCompleted' and 'InventoryRetrievalCompleted'."
  }

  validation {
    condition = var.notification == null || (
      var.notification != null &&
      can(regex("^arn:aws:sns:", var.notification.sns_topic))
    )
    error_message = "resource_aws_glacier_vault, notification sns_topic must be a valid SNS Topic ARN."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}