variable "description" {
  description = "Description of the client certificate"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || can(regex("^.{0,1024}$", var.description))
    error_message = "resource_aws_api_gateway_client_certificate, description must be 1024 characters or less."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_api_gateway_client_certificate, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_api_gateway_client_certificate, tags values must be 256 characters or less."
  }
}