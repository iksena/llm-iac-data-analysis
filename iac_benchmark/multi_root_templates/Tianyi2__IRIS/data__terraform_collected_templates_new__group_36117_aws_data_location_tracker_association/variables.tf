variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_location_tracker_association, region must be a valid AWS region format."
  }
}

variable "consumer_arn" {
  description = "ARN of the geofence collection associated to tracker resource"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:geo:[a-z0-9-]+:[0-9]+:geofence-collection/.+$", var.consumer_arn))
    error_message = "data_aws_location_tracker_association, consumer_arn must be a valid geofence collection ARN."
  }
}

variable "tracker_name" {
  description = "Name of the tracker resource associated with a geofence collection"
  type        = string

  validation {
    condition     = length(var.tracker_name) > 0 && length(var.tracker_name) <= 100
    error_message = "data_aws_location_tracker_association, tracker_name must be between 1 and 100 characters."
  }
}