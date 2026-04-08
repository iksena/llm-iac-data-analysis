variable "function_name" {
  description = "Name of the Lambda function"
  type        = string

  validation {
    condition     = length(var.function_name) > 0
    error_message = "resource_aws_lambda_invocation, function_name must not be empty."
  }
}

variable "input" {
  description = "JSON payload to the Lambda function"
  type        = string

  validation {
    condition     = length(var.input) > 0
    error_message = "resource_aws_lambda_invocation, input must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.input))
    error_message = "resource_aws_lambda_invocation, input must be valid JSON."
  }
}

variable "lifecycle_scope" {
  description = "Lifecycle scope of the resource to manage. Valid values are CREATE_ONLY and CRUD. Defaults to CREATE_ONLY"
  type        = string
  default     = "CREATE_ONLY"

  validation {
    condition     = contains(["CREATE_ONLY", "CRUD"], var.lifecycle_scope)
    error_message = "resource_aws_lambda_invocation, lifecycle_scope must be either CREATE_ONLY or CRUD."
  }
}

variable "qualifier" {
  description = "Qualifier (i.e., version) of the Lambda function. Defaults to $LATEST"
  type        = string
  default     = "$LATEST"

  validation {
    condition     = length(var.qualifier) > 0
    error_message = "resource_aws_lambda_invocation, qualifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_lambda_invocation, region must be a valid AWS region format."
  }
}

variable "terraform_key" {
  description = "JSON key used to store lifecycle information in the input JSON payload. Defaults to tf. This additional key is only included when lifecycle_scope is set to CRUD"
  type        = string
  default     = "tf"

  validation {
    condition     = length(var.terraform_key) > 0
    error_message = "resource_aws_lambda_invocation, terraform_key must not be empty."
  }
}

variable "triggers" {
  description = "Map of arbitrary keys and values that, when changed, will trigger a re-invocation"
  type        = map(string)
  default     = {}
}