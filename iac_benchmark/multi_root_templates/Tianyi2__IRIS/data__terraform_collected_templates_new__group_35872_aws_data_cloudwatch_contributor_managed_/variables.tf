variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_cloudwatch_contributor_managed_insight_rules, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}

variable "resource_arn" {
  description = "ARN of an Amazon Web Services resource that has managed Contributor Insights rules."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.resource_arn))
    error_message = "data_aws_cloudwatch_contributor_managed_insight_rules, resource_arn must be a valid AWS ARN starting with 'arn:aws:'."
  }

  validation {
    condition     = length(var.resource_arn) > 0
    error_message = "data_aws_cloudwatch_contributor_managed_insight_rules, resource_arn cannot be empty."
  }
}