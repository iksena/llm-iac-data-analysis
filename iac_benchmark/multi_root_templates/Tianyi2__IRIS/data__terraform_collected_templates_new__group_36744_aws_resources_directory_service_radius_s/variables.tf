variable "authentication_protocol" {
  description = "The protocol specified for your RADIUS endpoints"
  type        = string
  default     = null

  validation {
    condition = var.authentication_protocol == null || contains([
      "PAP", "CHAP", "MS-CHAPv1", "MS-CHAPv2"
    ], var.authentication_protocol)
    error_message = "resource_aws_directory_service_radius_settings, authentication_protocol must be one of: PAP, CHAP, MS-CHAPv1, MS-CHAPv2."
  }
}

variable "directory_id" {
  description = "The identifier of the directory for which you want to manager RADIUS settings"
  type        = string
}

variable "display_label" {
  description = "Display label"
  type        = string
}

variable "radius_port" {
  description = "The port that your RADIUS server is using for communications"
  type        = number
}

variable "radius_retries" {
  description = "The maximum number of times that communication with the RADIUS server is attempted"
  type        = number

  validation {
    condition     = var.radius_retries >= 0 && var.radius_retries <= 10
    error_message = "resource_aws_directory_service_radius_settings, radius_retries must be between 0 and 10."
  }
}

variable "radius_servers" {
  description = "An array of strings that contains the fully qualified domain name (FQDN) or IP addresses of the RADIUS server endpoints"
  type        = list(string)
}

variable "radius_timeout" {
  description = "The amount of time, in seconds, to wait for the RADIUS server to respond"
  type        = number

  validation {
    condition     = var.radius_timeout >= 1 && var.radius_timeout <= 50
    error_message = "resource_aws_directory_service_radius_settings, radius_timeout must be between 1 and 50."
  }
}

variable "shared_secret" {
  description = "Required for enabling RADIUS on the directory"
  type        = string
  sensitive   = true
}

variable "use_same_username" {
  description = "Not currently used"
  type        = bool
  default     = null
}

variable "timeouts" {
  description = "Timeouts configuration"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
  })
  default = null
}