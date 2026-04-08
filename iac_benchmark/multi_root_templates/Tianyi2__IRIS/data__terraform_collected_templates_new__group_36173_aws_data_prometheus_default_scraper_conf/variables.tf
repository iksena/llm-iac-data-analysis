variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_prometheus_default_scraper_configuration, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}