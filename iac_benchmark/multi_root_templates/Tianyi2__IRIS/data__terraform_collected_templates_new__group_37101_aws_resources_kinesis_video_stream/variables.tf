variable "name" {
  description = "A name to identify the stream. This is unique to the AWS account and region the Stream is created in."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_kinesis_video_stream, name must not be empty."
  }
}

variable "data_retention_in_hours" {
  description = "The number of hours that you want to retain the data in the stream. Kinesis Video Streams retains the data in a data store that is associated with the stream. The default value is 0, indicating that the stream does not persist data."
  type        = number
  default     = 0

  validation {
    condition     = var.data_retention_in_hours >= 0
    error_message = "resource_aws_kinesis_video_stream, data_retention_in_hours must be greater than or equal to 0."
  }
}

variable "device_name" {
  description = "The name of the device that is writing to the stream. In the current implementation, Kinesis Video Streams does not use this name."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "The ID of the AWS Key Management Service (AWS KMS) key that you want Kinesis Video Streams to use to encrypt stream data. If no key ID is specified, the default, Kinesis Video-managed key (aws/kinesisvideo) is used."
  type        = string
  default     = null
}

variable "media_type" {
  description = "The media type of the stream. Consumers of the stream can use this information when processing the stream."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "120m")
    delete = optional(string, "120m")
  })
  default = null
}