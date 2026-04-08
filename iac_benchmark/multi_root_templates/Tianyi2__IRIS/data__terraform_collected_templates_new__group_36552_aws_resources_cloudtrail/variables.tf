variable "name" {
  description = "Name of the trail"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket designated for publishing log files"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "advanced_event_selector" {
  description = "Specifies an advanced event selector for enabling data event logging"
  type = list(object({
    name = optional(string)
    field_selector = list(object({
      field           = string
      ends_with       = optional(list(string))
      equals          = optional(list(string))
      not_ends_with   = optional(list(string))
      not_equals      = optional(list(string))
      not_starts_with = optional(list(string))
      starts_with     = optional(list(string))
    }))
  }))
  default = []

  validation {
    condition = alltrue([
      for selector in var.advanced_event_selector : alltrue([
        for field in selector.field_selector : contains([
          "readOnly", "eventSource", "eventName", "eventCategory", "resources.type", "resources.ARN"
        ], field.field)
      ])
    ])
    error_message = "resource_aws_cloudtrail, advanced_event_selector: field must be one of: readOnly, eventSource, eventName, eventCategory, resources.type, resources.ARN."
  }
}

variable "cloud_watch_logs_group_arn" {
  description = "Log group name using an ARN that represents the log group to which CloudTrail logs will be delivered"
  type        = string
  default     = null
}

variable "cloud_watch_logs_role_arn" {
  description = "Role for the CloudWatch Logs endpoint to assume to write to a user's log group"
  type        = string
  default     = null
}

variable "enable_log_file_validation" {
  description = "Whether log file integrity validation is enabled"
  type        = bool
  default     = false
}

variable "enable_logging" {
  description = "Enables logging for the trail"
  type        = bool
  default     = true
}

variable "event_selector" {
  description = "Specifies an event selector for enabling data event logging"
  type = list(object({
    read_write_type                  = optional(string, "All")
    include_management_events        = optional(bool, true)
    exclude_management_event_sources = optional(set(string))
    data_resource = optional(list(object({
      type   = string
      values = list(string)
    })), [])
  }))
  default = []

  validation {
    condition = alltrue([
      for selector in var.event_selector : contains(["ReadOnly", "WriteOnly", "All"], selector.read_write_type)
    ])
    error_message = "resource_aws_cloudtrail, event_selector: read_write_type must be one of: ReadOnly, WriteOnly, All."
  }

  validation {
    condition = alltrue([
      for selector in var.event_selector : alltrue([
        for data_res in selector.data_resource : contains([
          "AWS::S3::Object", "AWS::Lambda::Function", "AWS::DynamoDB::Table"
        ], data_res.type)
      ])
    ])
    error_message = "resource_aws_cloudtrail, event_selector: data_resource type must be one of: AWS::S3::Object, AWS::Lambda::Function, AWS::DynamoDB::Table."
  }

  validation {
    condition = alltrue([
      for selector in var.event_selector :
      selector.exclude_management_event_sources == null || selector.include_management_events == true
    ])
    error_message = "resource_aws_cloudtrail, event_selector: exclude_management_event_sources requires include_management_events to be true."
  }

  validation {
    condition = alltrue([
      for selector in var.event_selector :
      selector.exclude_management_event_sources == null || alltrue([
        for source in selector.exclude_management_event_sources : contains([
          "kms.amazonaws.com", "rdsdata.amazonaws.com"
        ], source)
      ])
    ])
    error_message = "resource_aws_cloudtrail, event_selector: exclude_management_event_sources must contain only: kms.amazonaws.com, rdsdata.amazonaws.com."
  }
}

variable "include_global_service_events" {
  description = "Whether the trail is publishing events from global services such as IAM to the log files"
  type        = bool
  default     = true
}

variable "insight_selector" {
  description = "Configuration block for identifying unusual operational activity"
  type = list(object({
    insight_type = string
  }))
  default = []

  validation {
    condition = alltrue([
      for selector in var.insight_selector : contains([
        "ApiCallRateInsight", "ApiErrorRateInsight"
      ], selector.insight_type)
    ])
    error_message = "resource_aws_cloudtrail, insight_selector: insight_type must be one of: ApiCallRateInsight, ApiErrorRateInsight."
  }
}

variable "is_multi_region_trail" {
  description = "Whether the trail is created in the current region or in all regions"
  type        = bool
  default     = false
}

variable "is_organization_trail" {
  description = "Whether the trail is an AWS Organizations trail"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "KMS key ARN to use to encrypt the logs delivered by CloudTrail"
  type        = string
  default     = null
}

variable "s3_key_prefix" {
  description = "S3 key prefix that follows the name of the bucket you have designated for log file delivery"
  type        = string
  default     = null
}

variable "sns_topic_name" {
  description = "Name of the Amazon SNS topic defined for notification of log file delivery"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the trail"
  type        = map(string)
  default     = {}
}