variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A name to identify the stream. This is unique to the AWS account and region the Stream is created in."
  type        = string
}

variable "shard_count" {
  description = "The number of shards that the stream will use. If the stream_mode is PROVISIONED, this field is required."
  type        = number
  default     = null

  validation {
    condition     = var.shard_count == null || var.shard_count > 0
    error_message = "resource_aws_kinesis_stream, shard_count must be greater than 0."
  }
}

variable "retention_period" {
  description = "Length of time data records are accessible after they are added to the stream. The maximum value of a stream's retention period is 8760 hours. Minimum value is 24. Default is 24."
  type        = number
  default     = 24

  validation {
    condition     = var.retention_period >= 24 && var.retention_period <= 8760
    error_message = "resource_aws_kinesis_stream, retention_period must be between 24 and 8760 hours."
  }
}

variable "shard_level_metrics" {
  description = "A list of shard-level CloudWatch metrics which can be enabled for the stream."
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for metric in var.shard_level_metrics :
      contains([
        "IncomingBytes", "IncomingRecords", "OutgoingBytes", "OutgoingRecords",
        "WriteProvisionedThroughputExceeded", "ReadProvisionedThroughputExceeded",
        "IteratorAgeMilliseconds", "ALL"
      ], metric)
    ])
    error_message = "resource_aws_kinesis_stream, shard_level_metrics must contain valid CloudWatch metrics."
  }
}

variable "enforce_consumer_deletion" {
  description = "A boolean that indicates all registered consumers should be deregistered from the stream so that the stream can be destroyed without error. The default value is false."
  type        = bool
  default     = false
}

variable "encryption_type" {
  description = "The encryption type to use. The only acceptable values are NONE or KMS. The default value is NONE."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["NONE", "KMS"], var.encryption_type)
    error_message = "resource_aws_kinesis_stream, encryption_type must be either 'NONE' or 'KMS'."
  }
}

variable "kms_key_id" {
  description = "The GUID for the customer-managed KMS key to use for encryption. You can also use a Kinesis-owned master key by specifying the alias alias/aws/kinesis."
  type        = string
  default     = null
}

variable "stream_mode_details" {
  description = "Indicates the capacity mode of the data stream."
  type = object({
    stream_mode = string
  })
  default = null

  validation {
    condition     = var.stream_mode_details == null || contains(["PROVISIONED", "ON_DEMAND"], var.stream_mode_details.stream_mode)
    error_message = "resource_aws_kinesis_stream, stream_mode must be either 'PROVISIONED' or 'ON_DEMAND'."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "timeouts_create" {
  description = "Timeout for create operations."
  type        = string
  default     = "5m"
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "120m"
}

variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "120m"
}