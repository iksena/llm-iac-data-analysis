variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "type" {
  description = "Type of AWS resource collection to create. Valid values are AWS_CLOUD_FORMATION, AWS_SERVICE, and AWS_TAGS."
  type        = string

  validation {
    condition = contains([
      "AWS_CLOUD_FORMATION",
      "AWS_SERVICE",
      "AWS_TAGS"
    ], var.type)
    error_message = "data_aws_devopsguru_resource_collection, type must be one of: AWS_CLOUD_FORMATION, AWS_SERVICE, AWS_TAGS."
  }
}