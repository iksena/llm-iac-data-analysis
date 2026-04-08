variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_ebs_encryption_by_default, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "enabled" {
  description = "Whether or not default EBS encryption is enabled"
  type        = bool
  default     = true

  validation {
    condition     = can(tobool(var.enabled))
    error_message = "resource_aws_ebs_encryption_by_default, enabled must be a boolean value (true or false)."
  }
}