variable "arn" {
  description = "ARN to parse"
  type        = string

  validation {
    condition     = can(regex("^arn:", var.arn))
    error_message = "data_aws_arn, arn must be a valid ARN starting with 'arn:'."
  }
}