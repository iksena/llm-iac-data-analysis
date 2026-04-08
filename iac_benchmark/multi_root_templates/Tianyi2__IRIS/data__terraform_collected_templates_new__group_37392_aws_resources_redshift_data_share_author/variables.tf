variable "consumer_identifier" {
  description = "Identifier of the data consumer that is authorized to access the datashare. This identifier is an AWS account ID or a keyword, such as ADX."
  type        = string

  validation {
    condition     = can(regex("^([0-9]{12}|ADX)$", var.consumer_identifier))
    error_message = "resource_aws_redshift_data_share_authorization, consumer_identifier must be a valid 12-digit AWS account ID or the keyword 'ADX'."
  }
}

variable "data_share_arn" {
  description = "Amazon Resource Name (ARN) of the datashare that producers are to authorize sharing for."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:redshift:[a-z0-9-]+:[0-9]{12}:datashare:[a-z0-9-]+/.+$", var.data_share_arn))
    error_message = "resource_aws_redshift_data_share_authorization, data_share_arn must be a valid Redshift datashare ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_redshift_data_share_authorization, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "allow_writes" {
  description = "Whether to allow write operations for a datashare."
  type        = bool
  default     = null
}