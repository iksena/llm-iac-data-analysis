variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "log_group_arn_list" {
  description = "Array containing the ARN of the log group that this anomaly detector will watch. You can specify only one log group ARN."
  type        = list(string)

  validation {
    condition     = length(var.log_group_arn_list) == 1
    error_message = "resource_aws_cloudwatch_log_anomaly_detector, log_group_arn_list must contain exactly one log group ARN."
  }

  validation {
    condition = alltrue([
      for arn in var.log_group_arn_list : can(regex("^arn:aws:logs:", arn))
    ])
    error_message = "resource_aws_cloudwatch_log_anomaly_detector, log_group_arn_list must contain valid CloudWatch Logs ARNs."
  }
}

variable "anomaly_visibility_time" {
  description = "Number of days to have visibility on an anomaly. After this time period has elapsed for an anomaly, it will be automatically baselined and the anomaly detector will treat new occurrences of a similar anomaly as normal."
  type        = number
  default     = null

  validation {
    condition     = var.anomaly_visibility_time == null || (var.anomaly_visibility_time >= 7 && var.anomaly_visibility_time <= 90)
    error_message = "resource_aws_cloudwatch_log_anomaly_detector, anomaly_visibility_time must be between 7 and 90 days inclusive."
  }
}

variable "detector_name" {
  description = "Name for this anomaly detector."
  type        = string
  default     = null
}

variable "evaluation_frequency" {
  description = "Specifies how often the anomaly detector is to run and look for anomalies. Set this value according to the frequency that the log group receives new logs."
  type        = string
  default     = null

  validation {
    condition = var.evaluation_frequency == null || contains([
      "ONE_MIN",
      "FIVE_MIN",
      "TEN_MIN",
      "FIFTEEN_MIN",
      "THIRTY_MIN",
      "ONE_HOUR"
    ], var.evaluation_frequency)
    error_message = "resource_aws_cloudwatch_log_anomaly_detector, evaluation_frequency must be one of: ONE_MIN, FIVE_MIN, TEN_MIN, FIFTEEN_MIN, THIRTY_MIN, ONE_HOUR."
  }
}

variable "filter_pattern" {
  description = "You can use this parameter to limit the anomaly detection model to examine only log events that match the pattern you specify here."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "Optionally assigns a AWS KMS key to secure this anomaly detector and its findings. If a key is assigned, the anomalies found and the model used by this detector are encrypted at rest with the key."
  type        = string
  default     = null
}

variable "enabled" {
  description = "Controls whether CloudWatch anomaly detection is enabled for this detector."
  type        = bool
  default     = true
}