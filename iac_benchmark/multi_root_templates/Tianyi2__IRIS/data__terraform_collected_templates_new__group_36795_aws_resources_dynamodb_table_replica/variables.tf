variable "global_table_arn" {
  description = "ARN of the main or global table which this resource will replicate"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:dynamodb:", var.global_table_arn))
    error_message = "resource_aws_dynamodb_table_replica, global_table_arn must be a valid DynamoDB table ARN starting with 'arn:aws:dynamodb:'"
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "ARN of the CMK that should be used for the AWS KMS encryption. Forces new resource"
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null ? true : can(regex("^arn:aws:kms:", var.kms_key_arn))
    error_message = "resource_aws_dynamodb_table_replica, kms_key_arn must be a valid KMS key ARN starting with 'arn:aws:kms:' or null"
  }
}

variable "deletion_protection_enabled" {
  description = "Whether deletion protection is enabled (true) or disabled (false) on the table replica"
  type        = bool
  default     = null
}

variable "point_in_time_recovery" {
  description = "Whether to enable Point In Time Recovery for the table replica. Default is false"
  type        = bool
  default     = false
}

variable "table_class_override" {
  description = "Storage class of the table replica. Forces new resource"
  type        = string
  default     = null

  validation {
    condition     = var.table_class_override == null ? true : contains(["STANDARD", "STANDARD_INFREQUENT_ACCESS"], var.table_class_override)
    error_message = "resource_aws_dynamodb_table_replica, table_class_override must be either 'STANDARD' or 'STANDARD_INFREQUENT_ACCESS' or null"
  }
}

variable "tags" {
  description = "Map of tags to populate on the created table"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_dynamodb_table_replica, tags keys must be between 1-128 characters and values must be between 0-256 characters"
  }
}

variable "timeouts" {
  description = "Configuration block for operation timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "20m")
  })
  default = null

  validation {
    condition = var.timeouts == null ? true : alltrue([
      for timeout_value in [var.timeouts.create, var.timeouts.update, var.timeouts.delete] :
      timeout_value == null || can(regex("^[0-9]+(s|m|h)$", timeout_value))
    ])
    error_message = "resource_aws_dynamodb_table_replica, timeouts values must be valid duration strings (e.g., '30m', '1h', '120s') or null"
  }
}