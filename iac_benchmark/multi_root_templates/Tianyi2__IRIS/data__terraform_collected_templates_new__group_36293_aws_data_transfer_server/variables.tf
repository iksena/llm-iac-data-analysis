variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "server_id" {
  description = "ID for an SFTP server."
  type        = string

  validation {
    condition     = var.server_id != null && var.server_id != ""
    error_message = "data_aws_transfer_server, server_id cannot be null or empty."
  }
}