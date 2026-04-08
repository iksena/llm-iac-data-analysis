variable "name" {
  description = "The name of the activity to create"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_sfn_activity, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}
}

variable "encryption_configuration" {
  description = "Defines what encryption configuration is used to encrypt data in the Activity"
  type = object({
    kms_key_id                        = optional(string)
    type                              = string
    kms_data_key_reuse_period_seconds = optional(number)
  })
  default = null

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      contains(["AWS_KMS_KEY", "CUSTOMER_MANAGED_KMS_KEY"], var.encryption_configuration.type)
    )
    error_message = "resource_aws_sfn_activity, encryption_configuration.type must be one of: AWS_KMS_KEY, CUSTOMER_MANAGED_KMS_KEY."
  }

  validation {
    condition = var.encryption_configuration == null || (
      var.encryption_configuration != null &&
      var.encryption_configuration.kms_data_key_reuse_period_seconds == null ||
      (var.encryption_configuration.kms_data_key_reuse_period_seconds != null &&
        var.encryption_configuration.kms_data_key_reuse_period_seconds >= 60 &&
      var.encryption_configuration.kms_data_key_reuse_period_seconds <= 3600)
    )
    error_message = "resource_aws_sfn_activity, encryption_configuration.kms_data_key_reuse_period_seconds must be between 60 and 3600 seconds."
  }
}