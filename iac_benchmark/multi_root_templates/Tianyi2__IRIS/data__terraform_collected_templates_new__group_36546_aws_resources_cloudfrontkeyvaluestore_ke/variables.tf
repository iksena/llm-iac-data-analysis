variable "key" {
  description = "Key to put."
  type        = string

  validation {
    condition     = length(var.key) > 0
    error_message = "resource_aws_cloudfrontkeyvaluestore_key, key must not be empty."
  }
}

variable "key_value_store_arn" {
  description = "Amazon Resource Name (ARN) of the Key Value Store."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:cloudfront::[0-9]{12}:key-value-store/[a-zA-Z0-9-]+$", var.key_value_store_arn))
    error_message = "resource_aws_cloudfrontkeyvaluestore_key, key_value_store_arn must be a valid CloudFront Key Value Store ARN."
  }
}

variable "value" {
  description = "Value to put."
  type        = string

  validation {
    condition     = length(var.value) > 0
    error_message = "resource_aws_cloudfrontkeyvaluestore_key, value must not be empty."
  }
}