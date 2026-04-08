variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "source_name" {
  description = "Specify the name for a third-party custom source. This must be a Regionally unique value. Has a maximum length of 20."
  type        = string

  validation {
    condition     = length(var.source_name) <= 20
    error_message = "resource_aws_securitylake_custom_log_source, source_name must have a maximum length of 20 characters."
  }

  validation {
    condition     = var.source_name != ""
    error_message = "resource_aws_securitylake_custom_log_source, source_name cannot be empty."
  }
}

variable "source_version" {
  description = "Specify the source version for the third-party custom source, to limit log collection to a specific version of custom data source."
  type        = string
  default     = null
}

variable "event_classes" {
  description = "The Open Cybersecurity Schema Framework (OCSF) event classes which describes the type of data that the custom source will send to Security Lake."
  type        = list(string)
  default     = null
}

variable "crawler_configuration_role_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS Identity and Access Management (IAM) role to be used by the AWS Glue crawler."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.crawler_configuration_role_arn))
    error_message = "resource_aws_securitylake_custom_log_source, crawler_configuration_role_arn must be a valid IAM role ARN."
  }
}

variable "provider_identity_external_id" {
  description = "The external ID used to establish trust relationship with the AWS identity."
  type        = string

  validation {
    condition     = var.provider_identity_external_id != ""
    error_message = "resource_aws_securitylake_custom_log_source, provider_identity_external_id cannot be empty."
  }
}

variable "provider_identity_principal" {
  description = "The AWS identity principal."
  type        = string

  validation {
    condition     = var.provider_identity_principal != ""
    error_message = "resource_aws_securitylake_custom_log_source, provider_identity_principal cannot be empty."
  }

  validation {
    condition     = can(regex("^[0-9]{12}$", var.provider_identity_principal))
    error_message = "resource_aws_securitylake_custom_log_source, provider_identity_principal must be a 12-digit AWS account ID."
  }
}