variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_ebs_default_kms_key, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "read_timeout" {
  description = "Timeout for read operations"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[msh]$", var.read_timeout))
    error_message = "data_aws_ebs_default_kms_key, read_timeout must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}