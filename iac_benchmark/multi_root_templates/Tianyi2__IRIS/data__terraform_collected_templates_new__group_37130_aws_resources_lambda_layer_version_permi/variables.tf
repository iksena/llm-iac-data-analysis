variable "action" {
  description = "Action that will be allowed. lambda:GetLayerVersion is the standard value for layer access."
  type        = string

  validation {
    condition     = can(regex("^lambda:", var.action))
    error_message = "resource_aws_lambda_layer_version_permission, action must be a valid Lambda action starting with 'lambda:'."
  }
}

variable "layer_name" {
  description = "Name or ARN of the Lambda Layer."
  type        = string

  validation {
    condition     = length(var.layer_name) > 0
    error_message = "resource_aws_lambda_layer_version_permission, layer_name cannot be empty."
  }
}

variable "principal" {
  description = "AWS account ID that should be able to use your Lambda Layer. Use '*' to share with all AWS accounts."
  type        = string

  validation {
    condition     = length(var.principal) > 0
    error_message = "resource_aws_lambda_layer_version_permission, principal cannot be empty."
  }
}

variable "statement_id" {
  description = "Unique identifier for the permission statement."
  type        = string

  validation {
    condition     = length(var.statement_id) > 0
    error_message = "resource_aws_lambda_layer_version_permission, statement_id cannot be empty."
  }
}

variable "version_number" {
  description = "Version of Lambda Layer to grant access to. Note: permissions only apply to a single version of a layer."
  type        = number

  validation {
    condition     = var.version_number > 0
    error_message = "resource_aws_lambda_layer_version_permission, version_number must be greater than 0."
  }
}

variable "organization_id" {
  description = "AWS Organization ID that should be able to use your Lambda Layer. principal should be set to '*' when organization_id is provided."
  type        = string
  default     = null

  validation {
    condition = var.organization_id == null || (
      can(regex("^o-[a-z0-9]{10,32}$", var.organization_id))
    )
    error_message = "resource_aws_lambda_layer_version_permission, organization_id must be a valid AWS Organization ID (format: o-xxxxxxxxxx)."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "Whether to retain the permission when the resource is destroyed. Default is false."
  type        = bool
  default     = false
}