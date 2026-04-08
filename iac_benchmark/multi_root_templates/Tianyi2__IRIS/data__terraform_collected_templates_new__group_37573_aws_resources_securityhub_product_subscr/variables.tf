variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "product_arn" {
  type        = string
  description = "The ARN of the product that generates findings that you want to import into Security Hub."

  validation {
    condition     = can(regex("^arn:aws:securityhub:", var.product_arn))
    error_message = "resource_aws_securityhub_product_subscription, product_arn must be a valid Security Hub product ARN starting with 'arn:aws:securityhub:'."
  }
}