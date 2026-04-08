variable "comment" {
  description = "A comment to describe the key group."
  type        = string
  default     = null

  validation {
    condition     = var.comment == null || can(regex("^.{1,128}$", var.comment))
    error_message = "resource_aws_cloudfront_key_group, comment must be between 1 and 128 characters long."
  }
}

variable "items" {
  description = "A list of the identifiers of the public keys in the key group."
  type        = list(string)

  validation {
    condition     = length(var.items) > 0 && length(var.items) <= 5
    error_message = "resource_aws_cloudfront_key_group, items must contain between 1 and 5 public key identifiers."
  }

  validation {
    condition     = alltrue([for item in var.items : can(regex("^[A-Z0-9]{14}$", item))])
    error_message = "resource_aws_cloudfront_key_group, items must contain valid public key identifiers (14 character alphanumeric strings)."
  }
}

variable "name" {
  description = "A name to identify the key group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]{1,128}$", var.name))
    error_message = "resource_aws_cloudfront_key_group, name must be between 1 and 128 characters long and can only contain alphanumeric characters, hyphens, and underscores."
  }
}