variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null ? true : can(regex("^[a-z]{2}-[a-z]+-[0-9]{1,2}$", var.region))
    error_message = "data_aws_lambda_functions, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}