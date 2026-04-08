variable "key_value_store_arn" {
  description = "Amazon Resource Name (ARN) of the Key Value Store"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:cloudfront::[0-9]{12}:key-value-store/[a-zA-Z0-9-]+$", var.key_value_store_arn))
    error_message = "resource_aws_cloudfrontkeyvaluestore_keys_exclusive, key_value_store_arn must be a valid CloudFront Key Value Store ARN."
  }
}

variable "max_batch_size" {
  description = "Maximum resource key values pairs that will update in a single API request. AWS has a default quota of 50 keys or a 3 MB payload, whichever is reached first"
  type        = number
  default     = 50

  validation {
    condition     = var.max_batch_size > 0 && var.max_batch_size <= 50
    error_message = "resource_aws_cloudfrontkeyvaluestore_keys_exclusive, max_batch_size must be between 1 and 50."
  }
}

variable "resource_key_value_pairs" {
  description = "A list of all resource key value pairs associated with the KeyValueStore"
  type = list(object({
    key   = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for pair in var.resource_key_value_pairs : pair.key != ""
    ])
    error_message = "resource_aws_cloudfrontkeyvaluestore_keys_exclusive, resource_key_value_pairs key cannot be empty."
  }

  validation {
    condition = alltrue([
      for pair in var.resource_key_value_pairs : pair.value != ""
    ])
    error_message = "resource_aws_cloudfrontkeyvaluestore_keys_exclusive, resource_key_value_pairs value cannot be empty."
  }
}