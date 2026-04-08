variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the Profile Resource Association."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_route53profiles_resource_association, name must be a non-empty string."
  }
}

variable "profile_id" {
  description = "ID of the profile associated with the VPC."
  type        = string

  validation {
    condition     = length(var.profile_id) > 0
    error_message = "resource_aws_route53profiles_resource_association, profile_id must be a non-empty string."
  }
}

variable "resource_arn" {
  description = "Resource ID of the resource to be associated with the profile."
  type        = string

  validation {
    condition     = length(var.resource_arn) > 0
    error_message = "resource_aws_route53profiles_resource_association, resource_arn must be a non-empty string."
  }

  validation {
    condition     = can(regex("^arn:aws:", var.resource_arn))
    error_message = "resource_aws_route53profiles_resource_association, resource_arn must be a valid AWS ARN starting with 'arn:aws:'."
  }
}

variable "resource_properties" {
  description = "Resource properties for the resource to be associated with the profile."
  type        = string
  default     = null
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_route53profiles_resource_association, timeouts_create must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}


variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_route53profiles_resource_association, timeouts_delete must be a valid timeout format (e.g., '30m', '1h', '300s')."
  }
}