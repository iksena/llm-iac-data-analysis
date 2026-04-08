variable "reference_name" {
  type        = string
  description = "This is a reference name used in Caller Reference (helpful for identifying single delegation set amongst others)"
  default     = null

  validation {
    condition     = var.reference_name == null ? true : length(var.reference_name) > 0
    error_message = "resource_aws_route53_delegation_set, reference_name must not be an empty string if provided."
  }
}