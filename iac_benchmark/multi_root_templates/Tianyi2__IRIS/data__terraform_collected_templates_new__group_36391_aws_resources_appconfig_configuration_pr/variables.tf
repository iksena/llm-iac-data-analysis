variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "application_id" {
  description = "Application ID. Must be between 4 and 7 characters in length."
  type        = string

  validation {
    condition     = length(var.application_id) >= 4 && length(var.application_id) <= 7
    error_message = "resource_aws_appconfig_configuration_profile, application_id must be between 4 and 7 characters in length."
  }
}

variable "location_uri" {
  description = "URI to locate the configuration. You can specify the AWS AppConfig hosted configuration store, Systems Manager (SSM) document, an SSM Parameter Store parameter, or an Amazon S3 object. For the hosted configuration store, specify `hosted`. For an SSM document, specify either the document name in the format `ssm-document://<Document_name>` or the ARN. For a parameter, specify either the parameter name in the format `ssm-parameter://<Parameter_name>` or the ARN. For an Amazon S3 object, specify the URI in the following format: `s3://<bucket>/<objectKey>`."
  type        = string
}

variable "name" {
  description = "Name for the configuration profile. Must be between 1 and 128 characters in length."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 128
    error_message = "resource_aws_appconfig_configuration_profile, name must be between 1 and 128 characters in length."
  }
}

variable "description" {
  description = "Description of the configuration profile. Can be at most 1024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_appconfig_configuration_profile, description can be at most 1024 characters."
  }
}

variable "kms_key_identifier" {
  description = "The identifier for an Key Management Service key to encrypt new configuration data versions in the AppConfig hosted configuration store. This attribute is only used for hosted configuration types. The identifier can be an KMS key ID, alias, or the Amazon Resource Name (ARN) of the key ID or alias."
  type        = string
  default     = null
}

variable "retrieval_role_arn" {
  description = "ARN of an IAM role with permission to access the configuration at the specified `location_uri`. A retrieval role ARN is not required for configurations stored in the AWS AppConfig `hosted` configuration store. It is required for all other sources that store your configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider `default_tags` configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Type of configurations contained in the profile. Valid values: `AWS.AppConfig.FeatureFlags` and `AWS.Freeform`. Default: `AWS.Freeform`."
  type        = string
  default     = "AWS.Freeform"

  validation {
    condition     = contains(["AWS.AppConfig.FeatureFlags", "AWS.Freeform"], var.type)
    error_message = "resource_aws_appconfig_configuration_profile, type must be one of: AWS.AppConfig.FeatureFlags, AWS.Freeform."
  }
}

variable "validators" {
  description = "Set of methods for validating the configuration. Maximum of 2."
  type = list(object({
    content = optional(string)
    type    = optional(string)
  }))
  default = []

  validation {
    condition     = length(var.validators) <= 2
    error_message = "resource_aws_appconfig_configuration_profile, validators can have a maximum of 2 items."
  }

  validation {
    condition = alltrue([
      for validator in var.validators :
      validator.type == null || contains(["JSON_SCHEMA", "LAMBDA"], validator.type)
    ])
    error_message = "resource_aws_appconfig_configuration_profile, validators type must be one of: JSON_SCHEMA, LAMBDA."
  }

  validation {
    condition = alltrue([
      for validator in var.validators :
      validator.type != "LAMBDA" || validator.content != null
    ])
    error_message = "resource_aws_appconfig_configuration_profile, validators content is required when type is LAMBDA."
  }
}