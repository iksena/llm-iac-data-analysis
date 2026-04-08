variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "service_arn" {
  description = "The Amazon Resource Name (ARN) of the App Runner service to start the deployment for."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:apprunner:", var.service_arn))
    error_message = "resource_aws_apprunner_deployment, service_arn must be a valid App Runner service ARN."
  }
}