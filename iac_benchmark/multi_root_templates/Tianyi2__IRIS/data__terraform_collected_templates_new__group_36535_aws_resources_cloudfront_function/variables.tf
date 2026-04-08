variable "name" {
  description = "Unique name for your CloudFront Function."
  type        = string
}

variable "code" {
  description = "Source code of the function"
  type        = string
}

variable "runtime" {
  description = "Identifier of the function's runtime. Valid values are cloudfront-js-1.0 and cloudfront-js-2.0."
  type        = string
  validation {
    condition = contains([
      "cloudfront-js-1.0",
      "cloudfront-js-2.0"
    ], var.runtime)
    error_message = "resource_aws_cloudfront_function, runtime must be one of: cloudfront-js-1.0, cloudfront-js-2.0."
  }
}

variable "comment" {
  description = "Comment."
  type        = string
  default     = null
}

variable "publish" {
  description = "Whether to publish creation/change as Live CloudFront Function Version. Defaults to true."
  type        = bool
  default     = true
}

variable "key_value_store_associations" {
  description = "List of aws_cloudfront_key_value_store ARNs to be associated to the function. AWS limits associations to one key value store per function."
  type        = list(string)
  default     = null
  validation {
    condition = var.key_value_store_associations == null ? true : alltrue([
      for arn in var.key_value_store_associations :
      can(regex("^arn:aws:cloudfront::[0-9]{12}:key-value-store/[A-Za-z0-9-_]+$", arn))
    ])
    error_message = "resource_aws_cloudfront_function, key_value_store_associations must be valid CloudFront Key Value Store ARNs."
  }
}