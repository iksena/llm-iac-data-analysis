variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "internet_gateway_block_mode" {
  description = "Block mode. Needs to be one of block-bidirectional, block-ingress, off. If this resource is deleted, then this value will be set to off in the AWS account and region."
  type        = string

  validation {
    condition = contains([
      "block-bidirectional",
      "block-ingress",
      "off"
    ], var.internet_gateway_block_mode)
    error_message = "resource_aws_vpc_block_public_access_options, internet_gateway_block_mode must be one of: block-bidirectional, block-ingress, off."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}