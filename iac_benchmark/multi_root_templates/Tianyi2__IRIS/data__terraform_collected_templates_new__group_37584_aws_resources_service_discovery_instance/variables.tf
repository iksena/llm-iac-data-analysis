variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "The ID of the service instance."
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "resource_aws_service_discovery_instance, instance_id cannot be empty."
  }
}

variable "service_id" {
  description = "The ID of the service that you want to use to create the instance."
  type        = string

  validation {
    condition     = length(var.service_id) > 0
    error_message = "resource_aws_service_discovery_instance, service_id cannot be empty."
  }
}

variable "attributes" {
  description = "A map contains the attributes of the instance. Check the AWS documentation for the supported attributes and syntax."
  type        = map(string)

  validation {
    condition     = length(var.attributes) > 0
    error_message = "resource_aws_service_discovery_instance, attributes must contain at least one key-value pair."
  }
}