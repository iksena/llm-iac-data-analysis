variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_location_tracker, region must be a valid AWS region format (e.g., us-west-2)"
  }
}

variable "tracker_name" {
  description = "Name of the tracker resource."
  type        = string

  validation {
    condition     = length(var.tracker_name) > 0 && length(var.tracker_name) <= 100
    error_message = "data_aws_location_tracker, tracker_name must be between 1 and 100 characters"
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.tracker_name))
    error_message = "data_aws_location_tracker, tracker_name can only contain alphanumeric characters, periods, hyphens, and underscores"
  }
}