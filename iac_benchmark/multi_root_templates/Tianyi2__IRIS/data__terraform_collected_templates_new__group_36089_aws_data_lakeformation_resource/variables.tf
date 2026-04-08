variable "arn" {
  description = "ARN of the resource, an S3 path"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3:::", var.arn))
    error_message = "data_aws_lakeformation_resource, arn must be a valid S3 ARN starting with 'arn:aws:s3:::'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_lakeformation_resource, region must be a valid AWS region format or null."
  }
}