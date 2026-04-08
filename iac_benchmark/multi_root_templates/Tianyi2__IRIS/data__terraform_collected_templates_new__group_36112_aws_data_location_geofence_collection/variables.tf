variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}(-[a-z]+)*-[0-9]$", var.region))
    error_message = "data_aws_location_geofence_collection, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "collection_name" {
  description = "Name of the geofence collection."
  type        = string

  validation {
    condition     = length(var.collection_name) > 0 && length(var.collection_name) <= 100
    error_message = "data_aws_location_geofence_collection, collection_name must be between 1 and 100 characters in length."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._\\-]+$", var.collection_name))
    error_message = "data_aws_location_geofence_collection, collection_name can only contain alphanumeric characters, periods, underscores, and hyphens."
  }
}