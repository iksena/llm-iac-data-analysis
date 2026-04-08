variable "comment" {
  type        = string
  description = "An optional comment for the origin access identity"
  default     = null

  validation {
    condition     = var.comment == null || can(regex("^.{0,128}$", var.comment))
    error_message = "resource_aws_cloudfront_origin_access_identity, comment must be 128 characters or less."
  }
}