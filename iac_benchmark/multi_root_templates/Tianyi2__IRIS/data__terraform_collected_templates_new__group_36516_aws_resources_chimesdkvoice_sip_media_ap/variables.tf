variable "aws_region" {
  description = "The AWS Region in which the AWS Chime SDK Voice Sip Media Application is created."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9-]+$", var.aws_region))
    error_message = "resource_aws_chimesdkvoice_sip_media_application, aws_region must be a valid AWS region format."
  }
}

variable "endpoints" {
  description = "List of endpoints (Lambda Amazon Resource Names) specified for the SIP media application. Currently, only one endpoint is supported."
  type = list(object({
    lambda_arn = string
  }))

  validation {
    condition     = length(var.endpoints) == 1
    error_message = "resource_aws_chimesdkvoice_sip_media_application, endpoints must contain exactly one endpoint."
  }

  validation {
    condition     = can(regex("^arn:aws:lambda:", var.endpoints[0].lambda_arn))
    error_message = "resource_aws_chimesdkvoice_sip_media_application, endpoints lambda_arn must be a valid Lambda ARN."
  }
}

variable "name" {
  description = "The name of the AWS Chime SDK Voice Sip Media Application."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 256
    error_message = "resource_aws_chimesdkvoice_sip_media_application, name must be between 1 and 256 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_chimesdkvoice_sip_media_application, region must be a valid AWS region format when specified."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^[\\w\\s+=.@-]*$", k)) && can(regex("^[\\w\\s+=.@-]*$", v))])
    error_message = "resource_aws_chimesdkvoice_sip_media_application, tags keys and values must contain only valid characters."
  }
}