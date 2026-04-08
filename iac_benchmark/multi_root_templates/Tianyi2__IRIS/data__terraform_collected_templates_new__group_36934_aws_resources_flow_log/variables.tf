variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "traffic_type" {
  description = "The type of traffic to capture"
  type        = string
  validation {
    condition     = contains(["ACCEPT", "REJECT", "ALL"], var.traffic_type)
    error_message = "resource_aws_flow_log, traffic_type must be one of: ACCEPT, REJECT, ALL."
  }
}

variable "deliver_cross_account_role" {
  description = "ARN of the IAM role in the destination account used for cross-account delivery of flow logs"
  type        = string
  default     = null
}

variable "eni_id" {
  description = "Elastic Network Interface ID to attach to"
  type        = string
  default     = null
}

variable "iam_role_arn" {
  description = "ARN of the IAM role used to post flow logs"
  type        = string
  default     = null
}

variable "log_destination_type" {
  description = "Logging destination type"
  type        = string
  default     = "cloud-watch-logs"
  validation {
    condition     = contains(["cloud-watch-logs", "s3", "kinesis-data-firehose"], var.log_destination_type)
    error_message = "resource_aws_flow_log, log_destination_type must be one of: cloud-watch-logs, s3, kinesis-data-firehose."
  }
}

variable "log_destination" {
  description = "ARN of the logging destination"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "Subnet ID to attach to"
  type        = string
  default     = null
}

variable "transit_gateway_id" {
  description = "Transit Gateway ID to attach to"
  type        = string
  default     = null
}

variable "transit_gateway_attachment_id" {
  description = "Transit Gateway Attachment ID to attach to"
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "VPC ID to attach to"
  type        = string
  default     = null
}

variable "log_format" {
  description = "The fields to include in the flow log record"
  type        = string
  default     = null
}

variable "max_aggregation_interval" {
  description = "The maximum interval of time during which a flow of packets is captured and aggregated into a flow log record"
  type        = number
  default     = 600
  validation {
    condition     = contains([60, 600], var.max_aggregation_interval)
    error_message = "resource_aws_flow_log, max_aggregation_interval must be either 60 seconds (1 minute) or 600 seconds (10 minutes)."
  }
}

variable "destination_options" {
  description = "Describes the destination options for a flow log"
  type = object({
    file_format                = optional(string, "plain-text")
    hive_compatible_partitions = optional(bool, false)
    per_hour_partition         = optional(bool, false)
  })
  default = null
  validation {
    condition = var.destination_options == null || (
      var.destination_options.file_format == null ||
      contains(["plain-text", "parquet"], var.destination_options.file_format)
    )
    error_message = "resource_aws_flow_log, destination_options.file_format must be one of: plain-text, parquet."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

