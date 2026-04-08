variable "name" {
  description = "Name of the CloudFront function"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_cloudfront_function, name must not be empty."
  }
}

variable "stage" {
  description = "Function's stage, either DEVELOPMENT or LIVE"
  type        = string

  validation {
    condition     = contains(["DEVELOPMENT", "LIVE"], var.stage)
    error_message = "data_aws_cloudfront_function, stage must be either 'DEVELOPMENT' or 'LIVE'."
  }
}