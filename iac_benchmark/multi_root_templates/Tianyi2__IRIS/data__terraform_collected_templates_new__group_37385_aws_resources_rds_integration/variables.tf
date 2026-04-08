variable "integration_name" {
  description = "Name of the integration."
  type        = string

  validation {
    condition     = length(var.integration_name) > 0
    error_message = "resource_aws_rds_integration, integration_name cannot be empty."
  }
}

variable "source_arn" {
  description = "ARN of the database to use as the source for replication."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:rds:", var.source_arn))
    error_message = "resource_aws_rds_integration, source_arn must be a valid RDS ARN."
  }
}

variable "target_arn" {
  description = "ARN of the Redshift data warehouse to use as the target for replication."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:redshift", var.target_arn))
    error_message = "resource_aws_rds_integration, target_arn must be a valid Redshift ARN."
  }
}

variable "additional_encryption_context" {
  description = "Set of non-secret key–value pairs that contains additional contextual information about the data. You can only include this parameter if you specify the kms_key_id parameter."
  type        = map(string)
  default     = null

  validation {
    condition = var.additional_encryption_context == null || (
      var.additional_encryption_context != null && alltrue([
        for k, v in var.additional_encryption_context : k != "" && v != ""
      ])
    )
    error_message = "resource_aws_rds_integration, additional_encryption_context keys and values cannot be empty strings."
  }
}

variable "data_filter" {
  description = "Data filters for the integration. These filters determine which tables from the source database are sent to the target Amazon Redshift data warehouse. The value should match the syntax from the AWS CLI which includes an include: or exclude: prefix before a filter expression. Multiple expressions are separated by a comma."
  type        = string
  default     = null

  validation {
    condition = var.data_filter == null || (
      var.data_filter != null && can(regex("^(include:|exclude:)", var.data_filter))
    )
    error_message = "resource_aws_rds_integration, data_filter must start with 'include:' or 'exclude:' prefix."
  }
}

variable "kms_key_id" {
  description = "KMS key identifier for the key to use to encrypt the integration. If you don't specify an encryption key, RDS uses a default AWS owned key."
  type        = string
  default     = null

  validation {
    condition = var.kms_key_id == null || (
      var.kms_key_id != null && (
        can(regex("^arn:aws:kms:", var.kms_key_id)) ||
        can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.kms_key_id)) ||
        can(regex("^alias/", var.kms_key_id))
      )
    )
    error_message = "resource_aws_rds_integration, kms_key_id must be a valid KMS key ARN, key ID, or alias."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : k != "" && v != ""
    ])
    error_message = "resource_aws_rds_integration, tags keys and values cannot be empty strings."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "60m")
    update = optional(string, "10m")
    delete = optional(string, "30m")
  })
  default = null

  validation {
    condition = var.timeouts == null || (
      var.timeouts != null && alltrue([
        var.timeouts.create == null || can(regex("^[0-9]+[smh]$", var.timeouts.create)),
        var.timeouts.update == null || can(regex("^[0-9]+[smh]$", var.timeouts.update)),
        var.timeouts.delete == null || can(regex("^[0-9]+[smh]$", var.timeouts.delete))
      ])
    )
    error_message = "resource_aws_rds_integration, timeouts values must be in format like '60m', '10s', '1h'."
  }
}