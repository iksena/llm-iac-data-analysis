variable "arn" {
  description = "ARN of the image pipeline"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:imagebuilder:", var.arn))
    error_message = "data_aws_imagebuilder_image_pipeline, arn must be a valid Image Builder image pipeline ARN starting with 'arn:aws:imagebuilder:'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_imagebuilder_image_pipeline, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}