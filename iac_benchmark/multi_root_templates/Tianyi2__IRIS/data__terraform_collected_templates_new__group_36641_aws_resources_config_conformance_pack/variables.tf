variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the conformance pack. Must begin with a letter and contain from 1 to 256 alphanumeric characters and hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,255}$", var.name))
    error_message = "resource_aws_config_conformance_pack, name must begin with a letter and contain from 1 to 256 alphanumeric characters and hyphens."
  }
}

variable "delivery_s3_bucket" {
  description = "Amazon S3 bucket where AWS Config stores conformance pack templates. Maximum length of 63."
  type        = string
  default     = null

  validation {
    condition     = var.delivery_s3_bucket == null || length(var.delivery_s3_bucket) <= 63
    error_message = "resource_aws_config_conformance_pack, delivery_s3_bucket maximum length is 63 characters."
  }
}

variable "delivery_s3_key_prefix" {
  description = "The prefix for the Amazon S3 bucket. Maximum length of 1024."
  type        = string
  default     = null

  validation {
    condition     = var.delivery_s3_key_prefix == null || length(var.delivery_s3_key_prefix) <= 1024
    error_message = "resource_aws_config_conformance_pack, delivery_s3_key_prefix maximum length is 1024 characters."
  }
}

variable "input_parameters" {
  description = "Set of configuration blocks describing input parameters passed to the conformance pack template."
  type = list(object({
    parameter_name  = string
    parameter_value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.input_parameters : param.parameter_name != null && param.parameter_name != ""
    ])
    error_message = "resource_aws_config_conformance_pack, input_parameters parameter_name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for param in var.input_parameters : param.parameter_value != null && param.parameter_value != ""
    ])
    error_message = "resource_aws_config_conformance_pack, input_parameters parameter_value is required and cannot be empty."
  }
}

variable "template_body" {
  description = "A string containing full conformance pack template body. Maximum length of 51200. Required if template_s3_uri is not provided."
  type        = string
  default     = null

  validation {
    condition     = var.template_body == null || length(var.template_body) <= 51200
    error_message = "resource_aws_config_conformance_pack, template_body maximum length is 51200 characters."
  }
}

variable "template_s3_uri" {
  description = "Location of file containing the template body. Maximum length of 1024. Required if template_body is not provided."
  type        = string
  default     = null

  validation {
    condition     = var.template_s3_uri == null || length(var.template_s3_uri) <= 1024
    error_message = "resource_aws_config_conformance_pack, template_s3_uri maximum length is 1024 characters."
  }

  validation {
    condition     = var.template_s3_uri == null || can(regex("^s3://", var.template_s3_uri))
    error_message = "resource_aws_config_conformance_pack, template_s3_uri must be a valid S3 URI starting with s3://."
  }
}