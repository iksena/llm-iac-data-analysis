variable "arn" {
  description = "ARN of the image recipe"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:imagebuilder:[a-z0-9-]+:[0-9]{12}:image-recipe/.+", var.arn))
    error_message = "data_aws_imagebuilder_image_recipe, arn must be a valid Image Builder image recipe ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_imagebuilder_image_recipe, region must be a valid AWS region format (e.g., us-east-1)."
  }
}