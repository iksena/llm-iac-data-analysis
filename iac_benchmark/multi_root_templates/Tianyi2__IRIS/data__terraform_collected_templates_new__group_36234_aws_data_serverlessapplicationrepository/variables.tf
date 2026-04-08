variable "application_id" {
  description = "ARN of the application"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:serverlessrepo:", var.application_id))
    error_message = "data_aws_serverlessapplicationrepository_application, application_id must be a valid serverless application repository ARN starting with 'arn:aws:serverlessrepo:'."
  }
}

variable "semantic_version" {
  description = "Requested version of the application. By default, retrieves the latest version"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}