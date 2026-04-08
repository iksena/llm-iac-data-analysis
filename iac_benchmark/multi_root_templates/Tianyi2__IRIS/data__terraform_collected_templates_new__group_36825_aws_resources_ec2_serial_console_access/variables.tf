variable "enabled" {
  description = "Whether or not serial console access is enabled. Valid values are `true` or `false`. Defaults to `true`."
  type        = bool
  default     = true

  validation {
    condition     = can(regex("^(true|false)$", tostring(var.enabled)))
    error_message = "resource_aws_ec2_serial_console_access, enabled must be either true or false."
  }
}