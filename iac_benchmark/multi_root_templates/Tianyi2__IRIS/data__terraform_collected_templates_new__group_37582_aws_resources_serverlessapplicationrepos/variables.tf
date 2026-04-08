variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the stack to create. The resource deployed in AWS will be prefixed with `serverlessrepo-`"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_serverlessapplicationrepository_cloudformation_stack, name must not be empty."
  }
}

variable "application_id" {
  description = "The ARN of the application from the Serverless Application Repository."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:serverlessrepo:", var.application_id))
    error_message = "resource_aws_serverlessapplicationrepository_cloudformation_stack, application_id must be a valid Serverless Application Repository ARN."
  }
}

variable "capabilities" {
  description = "A list of capabilities. Valid values are CAPABILITY_IAM, CAPABILITY_NAMED_IAM, CAPABILITY_RESOURCE_POLICY, or CAPABILITY_AUTO_EXPAND"
  type        = list(string)

  validation {
    condition = alltrue([
      for capability in var.capabilities : contains([
        "CAPABILITY_IAM",
        "CAPABILITY_NAMED_IAM",
        "CAPABILITY_RESOURCE_POLICY",
        "CAPABILITY_AUTO_EXPAND"
      ], capability)
    ])
    error_message = "resource_aws_serverlessapplicationrepository_cloudformation_stack, capabilities must contain only valid values: CAPABILITY_IAM, CAPABILITY_NAMED_IAM, CAPABILITY_RESOURCE_POLICY, or CAPABILITY_AUTO_EXPAND."
  }
}

variable "parameters" {
  description = "A map of Parameter structures that specify input parameters for the stack."
  type        = map(string)
  default     = {}
}

variable "semantic_version" {
  description = "The version of the application to deploy. If not supplied, deploys the latest version."
  type        = string
  default     = null
}

variable "tags" {
  description = "A list of tags to associate with this stack."
  type        = map(string)
  default     = {}
}