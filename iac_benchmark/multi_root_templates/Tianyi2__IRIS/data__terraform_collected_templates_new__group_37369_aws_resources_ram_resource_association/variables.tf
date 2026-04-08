variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_ram_resource_association, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "resource_arn" {
  description = "Amazon Resource Name (ARN) of the resource to associate with the RAM Resource Share."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.resource_arn))
    error_message = "resource_aws_ram_resource_association, resource_arn must be a valid ARN starting with 'arn:aws:'."
  }
}

variable "resource_share_arn" {
  description = "Amazon Resource Name (ARN) of the RAM Resource Share."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:ram:", var.resource_share_arn))
    error_message = "resource_aws_ram_resource_association, resource_share_arn must be a valid RAM Resource Share ARN starting with 'arn:aws:ram:'."
  }
}