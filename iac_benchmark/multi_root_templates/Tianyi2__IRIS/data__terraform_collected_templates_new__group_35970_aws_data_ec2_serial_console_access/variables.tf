variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9][a-z]$", var.region))
    error_message = "data_aws_ec2_serial_console_access, region must be a valid AWS region format (e.g., us-west-2, us-east-1a)."
  }
}

variable "timeout_read" {
  description = "Timeout for the read operation."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smhd]$", var.timeout_read))
    error_message = "data_aws_ec2_serial_console_access, timeout_read must be a valid timeout format (e.g., 20m, 1h, 30s)."
  }
}