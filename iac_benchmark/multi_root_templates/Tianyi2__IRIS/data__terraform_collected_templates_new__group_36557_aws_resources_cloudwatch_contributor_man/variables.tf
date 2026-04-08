variable "resource_arn" {
  description = "ARN of an Amazon Web Services resource that has managed Contributor Insights rules"
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z0-9-]*:[a-z0-9-]+:[a-z0-9-]*:[0-9]*:[a-zA-Z0-9-_/]+$", var.resource_arn))
    error_message = "resource_aws_cloudwatch_contributor_managed_insight_rule, resource_arn must be a valid AWS ARN format."
  }
}

variable "template_name" {
  description = "Template name for the managed Contributor Insights rule, as returned by ListManagedInsightRules"
  type        = string

  validation {
    condition     = length(var.template_name) > 0
    error_message = "resource_aws_cloudwatch_contributor_managed_insight_rule, template_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

