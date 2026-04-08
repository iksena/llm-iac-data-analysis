variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "status" {
  description = "Whether Service Catalog is enabled or disabled in SageMaker. Valid values are Enabled and Disabled."
  type        = string

  validation {
    condition     = contains(["Enabled", "Disabled"], var.status)
    error_message = "resource_aws_sagemaker_servicecatalog_portfolio_status, status must be either 'Enabled' or 'Disabled'."
  }
}