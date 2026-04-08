variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_ecr_authorization_token, region must be a valid AWS region format."
  }
}

variable "registry_id" {
  description = "AWS account ID of the ECR Repository. If not specified the default account is assumed."
  type        = string
  default     = null

  validation {
    condition     = var.registry_id == null || can(regex("^[0-9]{12}$", var.registry_id))
    error_message = "data_aws_ecr_authorization_token, registry_id must be a valid 12-digit AWS account ID."
  }
}