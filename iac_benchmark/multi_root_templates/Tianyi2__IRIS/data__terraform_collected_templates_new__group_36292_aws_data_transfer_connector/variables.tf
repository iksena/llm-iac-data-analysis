variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_transfer_connector, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "id" {
  description = "Unique identifier for connector"
  type        = string

  validation {
    condition     = can(regex("^c-[a-zA-Z0-9]{17}$", var.id))
    error_message = "data_aws_transfer_connector, id must be a valid Transfer connector ID format starting with 'c-' followed by 17 alphanumeric characters."
  }
}