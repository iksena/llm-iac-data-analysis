variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "s3_destination" {
  description = "Configuration block for a S3 Destination"
  type = object({
    bucket_name = string
    key_prefix  = optional(string)
    kms_key_arn = string
  })

  validation {
    condition     = can(regex("^[a-zA-Z0-9\\._-]+$", var.s3_destination.bucket_name))
    error_message = "resource_aws_macie2_classification_export_configuration, bucket_name must be a valid S3 bucket name containing only alphanumeric characters, periods, hyphens, and underscores."
  }

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]{36}$", var.s3_destination.kms_key_arn))
    error_message = "resource_aws_macie2_classification_export_configuration, kms_key_arn must be a valid KMS key ARN."
  }

  validation {
    condition     = var.s3_destination.key_prefix == null || can(regex("^[a-zA-Z0-9!\\-_.*'()/]+$", var.s3_destination.key_prefix))
    error_message = "resource_aws_macie2_classification_export_configuration, key_prefix must contain only valid S3 object key characters."
  }
}