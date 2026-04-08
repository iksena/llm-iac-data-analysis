variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the organization conformance pack. Must begin with a letter and contain from 1 to 128 alphanumeric characters and hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,127}$", var.name))
    error_message = "resource_aws_config_organization_conformance_pack, name must begin with a letter and contain from 1 to 128 alphanumeric characters and hyphens."
  }
}

variable "delivery_s3_bucket" {
  description = "Amazon S3 bucket where AWS Config stores conformance pack templates. Delivery bucket must begin with awsconfigconforms prefix. Maximum length of 63."
  type        = string
  default     = null

  validation {
    condition = var.delivery_s3_bucket == null || (
      can(regex("^awsconfigconforms", var.delivery_s3_bucket)) &&
      length(var.delivery_s3_bucket) <= 63
    )
    error_message = "resource_aws_config_organization_conformance_pack, delivery_s3_bucket must begin with awsconfigconforms prefix and have maximum length of 63."
  }
}

variable "delivery_s3_key_prefix" {
  description = "The prefix for the Amazon S3 bucket. Maximum length of 1024."
  type        = string
  default     = null

  validation {
    condition     = var.delivery_s3_key_prefix == null || length(var.delivery_s3_key_prefix) <= 1024
    error_message = "resource_aws_config_organization_conformance_pack, delivery_s3_key_prefix must have maximum length of 1024."
  }
}

variable "excluded_accounts" {
  description = "Set of AWS accounts to be excluded from an organization conformance pack while deploying a conformance pack. Maximum of 1000 accounts."
  type        = set(string)
  default     = null

  validation {
    condition     = var.excluded_accounts == null || length(var.excluded_accounts) <= 1000
    error_message = "resource_aws_config_organization_conformance_pack, excluded_accounts must have maximum of 1000 accounts."
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
    error_message = "resource_aws_config_organization_conformance_pack, input_parameters parameter_name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for param in var.input_parameters : param.parameter_value != null && param.parameter_value != ""
    ])
    error_message = "resource_aws_config_organization_conformance_pack, input_parameters parameter_value is required and cannot be empty."
  }
}

variable "template_body" {
  description = "A string containing full conformance pack template body. Maximum length of 51200. Conflicts with template_s3_uri."
  type        = string
  default     = null

  validation {
    condition     = var.template_body == null || length(var.template_body) <= 51200
    error_message = "resource_aws_config_organization_conformance_pack, template_body must have maximum length of 51200."
  }
}

variable "template_s3_uri" {
  description = "Location of file, e.g., s3://bucketname/prefix, containing the template body. Maximum length of 1024. Conflicts with template_body."
  type        = string
  default     = null

  validation {
    condition     = var.template_s3_uri == null || length(var.template_s3_uri) <= 1024
    error_message = "resource_aws_config_organization_conformance_pack, template_s3_uri must have maximum length of 1024."
  }

  validation {
    condition     = var.template_s3_uri == null || can(regex("^s3://", var.template_s3_uri))
    error_message = "resource_aws_config_organization_conformance_pack, template_s3_uri must be a valid S3 URI starting with s3://."
  }
}

variable "timeouts" {
  description = "Configuration block for timeout settings"
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "20m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "20m"
  }
}