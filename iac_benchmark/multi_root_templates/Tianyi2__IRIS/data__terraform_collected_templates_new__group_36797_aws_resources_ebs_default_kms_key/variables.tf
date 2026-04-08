variable "key_arn" {
  description = "The ARN of the AWS Key Management Service (AWS KMS) customer master key (CMK) to use to encrypt the EBS volume."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:", var.key_arn))
    error_message = "resource_aws_ebs_default_kms_key, key_arn must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_ebs_default_kms_key, region must be a valid AWS region identifier containing only lowercase letters, numbers, and hyphens."
  }
}