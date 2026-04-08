variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "consumer_arn" {
  description = "The Amazon Resource Name (ARN) for the geofence collection to be associated to tracker resource. Used when you need to specify a resource across all AWS."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:geo:", var.consumer_arn))
    error_message = "resource_aws_location_tracker_association, consumer_arn must be a valid AWS Location ARN starting with 'arn:aws:geo:'."
  }
}

variable "tracker_name" {
  description = "The name of the tracker resource to be associated with a geofence collection."
  type        = string

  validation {
    condition     = length(var.tracker_name) > 0 && length(var.tracker_name) <= 100
    error_message = "resource_aws_location_tracker_association, tracker_name must be between 1 and 100 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.tracker_name))
    error_message = "resource_aws_location_tracker_association, tracker_name must contain only alphanumeric characters, hyphens, periods, and underscores."
  }
}

variable "timeouts_create" {
  description = "Timeout for creating the tracker association."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_create))
    error_message = "resource_aws_location_tracker_association, timeouts_create must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for deleting the tracker association."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_location_tracker_association, timeouts_delete must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}