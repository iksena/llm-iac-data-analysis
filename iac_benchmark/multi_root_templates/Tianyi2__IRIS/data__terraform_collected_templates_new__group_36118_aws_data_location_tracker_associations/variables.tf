variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tracker_name" {
  description = "Name of the tracker resource associated with a geofence collection."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.tracker_name))
    error_message = "data_aws_location_tracker_associations, tracker_name must contain only alphanumeric characters, hyphens, periods, and underscores."
  }

  validation {
    condition     = length(var.tracker_name) >= 1 && length(var.tracker_name) <= 100
    error_message = "data_aws_location_tracker_associations, tracker_name must be between 1 and 100 characters in length."
  }
}