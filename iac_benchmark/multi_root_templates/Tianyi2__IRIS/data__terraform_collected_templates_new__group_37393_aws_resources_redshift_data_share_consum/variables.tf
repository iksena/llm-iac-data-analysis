variable "data_share_arn" {
  description = "Amazon Resource Name (ARN) of the datashare that the consumer is to use with the account or the namespace."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:redshift:", var.data_share_arn))
    error_message = "resource_aws_redshift_data_share_consumer_association, data_share_arn must be a valid Redshift datashare ARN starting with 'arn:aws:redshift:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "allow_writes" {
  description = "Whether to allow write operations for a datashare."
  type        = bool
  default     = null
}

variable "associate_entire_account" {
  description = "Whether the datashare is associated with the entire account. Conflicts with consumer_arn and consumer_region."
  type        = bool
  default     = null
}

variable "consumer_arn" {
  description = "Amazon Resource Name (ARN) of the consumer that is associated with the datashare. Conflicts with associate_entire_account and consumer_region."
  type        = string
  default     = null

  validation {
    condition     = var.consumer_arn == null || can(regex("^arn:aws:", var.consumer_arn))
    error_message = "resource_aws_redshift_data_share_consumer_association, consumer_arn must be a valid ARN starting with 'arn:aws:' when specified."
  }
}

variable "consumer_region" {
  description = "From a datashare consumer account, associates a datashare with all existing and future namespaces in the specified AWS Region. Conflicts with associate_entire_account and consumer_arn."
  type        = string
  default     = null
}

# Validation for mutual exclusivity
locals {
  consumer_options_count = length([
    for option in [var.associate_entire_account, var.consumer_arn, var.consumer_region] : option
    if option != null
  ])
}

variable "validate_consumer_options" {
  description = "Internal validation variable - do not set directly"
  type        = bool
  default     = true

  validation {
    condition     = var.validate_consumer_options ? local.consumer_options_count <= 1 : true
    error_message = "resource_aws_redshift_data_share_consumer_association, associate_entire_account, consumer_arn, and consumer_region are mutually exclusive - only one can be specified."
  }
}