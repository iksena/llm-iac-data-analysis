variable "name" {
  description = "Name of the application"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,98}[a-zA-Z0-9]$", var.name)) || length(var.name) == 1
    error_message = "data_aws_elastic_beanstalk_application, name must be between 1 and 100 characters and can contain letters, numbers, and hyphens, but cannot start or end with a hyphen."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_elastic_beanstalk_application, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}