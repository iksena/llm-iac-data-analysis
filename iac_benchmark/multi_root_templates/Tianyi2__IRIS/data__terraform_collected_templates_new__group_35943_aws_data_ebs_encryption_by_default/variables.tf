variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ebs_encryption_by_default, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    read = optional(string, "20m")
  })
  default = {
    read = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.read))
    error_message = "data_aws_ebs_encryption_by_default, timeouts.read must be a valid duration format (e.g., 20m, 1h, 30s)."
  }
}