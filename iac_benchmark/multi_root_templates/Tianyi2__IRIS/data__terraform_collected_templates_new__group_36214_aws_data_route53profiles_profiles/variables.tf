variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]+-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_route53profiles_profiles, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null to use provider default."
  }
}