variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "data_set_id" {
  description = "The ID of the data set to monitor for revision publications. Changing this value will recreate the resource."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.data_set_id))
    error_message = "resource_aws_dataexchange_event_action, data_set_id must be a valid data set identifier."
  }
}

variable "revision_destination_bucket" {
  description = "The S3 bucket where the revision will be exported."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]*[a-z0-9]$", var.revision_destination_bucket)) && length(var.revision_destination_bucket) >= 3 && length(var.revision_destination_bucket) <= 63
    error_message = "resource_aws_dataexchange_event_action, revision_destination_bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, periods, and hyphens only)."
  }
}

variable "revision_destination_key_pattern" {
  description = "Pattern for naming revisions in the S3 bucket. Defaults to $${Revision.CreatedAt}/$${Asset.Name}."
  type        = string
  default     = "$${Revision.CreatedAt}/$${Asset.Name}"
}

variable "encryption" {
  description = "Configures server-side encryption of the exported revision."
  type = object({
    type        = optional(string)
    kms_key_arn = optional(string)
  })
  default = null

  validation {
    condition = var.encryption == null || (
      var.encryption.type == null || contains(["aws:kms", "aws:s3"], var.encryption.type)
    )
    error_message = "resource_aws_dataexchange_event_action, encryption.type must be either 'aws:kms' or 'aws:s3'."
  }

  validation {
    condition = var.encryption == null || (
      var.encryption.type != "aws:kms" || var.encryption.kms_key_arn != null
    )
    error_message = "resource_aws_dataexchange_event_action, encryption.kms_key_arn is required when encryption.type is 'aws:kms'."
  }

  validation {
    condition     = var.encryption == null || var.encryption.kms_key_arn == null || can(regex("^arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]{36}$", var.encryption.kms_key_arn))
    error_message = "resource_aws_dataexchange_event_action, encryption.kms_key_arn must be a valid KMS key ARN."
  }
}