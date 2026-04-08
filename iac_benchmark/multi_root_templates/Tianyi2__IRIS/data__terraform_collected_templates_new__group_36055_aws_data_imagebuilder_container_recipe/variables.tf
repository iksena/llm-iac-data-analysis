variable "arn" {
  description = "ARN of the container recipe."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:imagebuilder:", var.arn))
    error_message = "data_aws_imagebuilder_container_recipe, arn must be a valid Image Builder container recipe ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}