variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "detector_id" {
  description = "The detector ID of the GuardDuty."
  type        = string

  validation {
    condition     = length(var.detector_id) > 0
    error_message = "resource_aws_guardduty_publishing_destination, detector_id must be a non-empty string."
  }
}

variable "destination_arn" {
  description = "The bucket arn and prefix under which the findings get exported. Bucket-ARN is required, the prefix is optional and will be AWSLogs/[Account-ID]/GuardDuty/[Region]/ if not provided."
  type        = string

  validation {
    condition     = length(var.destination_arn) > 0 && can(regex("^arn:aws:s3:::", var.destination_arn))
    error_message = "resource_aws_guardduty_publishing_destination, destination_arn must be a valid S3 bucket ARN starting with 'arn:aws:s3:::'."
  }
}

variable "kms_key_arn" {
  description = "The ARN of the KMS key used to encrypt GuardDuty findings. GuardDuty enforces this to be encrypted."
  type        = string

  validation {
    condition     = length(var.kms_key_arn) > 0 && can(regex("^arn:aws:kms:", var.kms_key_arn))
    error_message = "resource_aws_guardduty_publishing_destination, kms_key_arn must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }
}

variable "destination_type" {
  description = "Currently there is only S3 available as destination type which is also the default value."
  type        = string
  default     = "S3"

  validation {
    condition     = var.destination_type == "S3"
    error_message = "resource_aws_guardduty_publishing_destination, destination_type must be 'S3' as it is currently the only supported destination type."
  }
}