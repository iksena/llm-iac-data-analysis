variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the SSM document to apply."
  type        = string
  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssm_association, name must not be empty."
  }
}

variable "apply_only_at_cron_interval" {
  description = "By default, when you create a new or update associations, the system runs it immediately and then according to the schedule you specified. Enable this option if you do not want an association to run immediately after you create or update it. This parameter is not supported for rate expressions. Default: false."
  type        = bool
  default     = false
}

variable "association_name" {
  description = "The descriptive name for the association."
  type        = string
  default     = null
}

variable "automation_target_parameter_name" {
  description = "Specify the target for the association. This target is required for associations that use an Automation document and target resources by using rate controls. This should be set to the SSM document parameter that will define how your automation will branch out."
  type        = string
  default     = null
}

variable "compliance_severity" {
  description = "The compliance severity for the association. Can be one of the following: UNSPECIFIED, LOW, MEDIUM, HIGH or CRITICAL"
  type        = string
  default     = null
  validation {
    condition = var.compliance_severity == null || contains([
      "UNSPECIFIED", "LOW", "MEDIUM", "HIGH", "CRITICAL"
    ], var.compliance_severity)
    error_message = "resource_aws_ssm_association, compliance_severity must be one of: UNSPECIFIED, LOW, MEDIUM, HIGH, CRITICAL."
  }
}

variable "document_version" {
  description = "The document version you want to associate with the target(s). Can be a specific version or the default version."
  type        = string
  default     = null
}

variable "max_concurrency" {
  description = "The maximum number of targets allowed to run the association at the same time. You can specify a number, for example 10, or a percentage of the target set, for example 10%."
  type        = string
  default     = null
}

variable "max_errors" {
  description = "The number of errors that are allowed before the system stops sending requests to run the association on additional targets. You can specify a number, for example 10, or a percentage of the target set, for example 10%. If you specify a threshold of 3, the stop command is sent when the fourth error is returned. If you specify a threshold of 10% for 50 associations, the stop command is sent when the sixth error is returned."
  type        = string
  default     = null
}

variable "output_location" {
  description = "An output location block. Output Location is an S3 bucket where you want to store the results of this association."
  type = object({
    s3_bucket_name = string
    s3_key_prefix  = optional(string)
    s3_region      = optional(string)
  })
  default = null
  validation {
    condition = var.output_location == null || (
      var.output_location != null && length(var.output_location.s3_bucket_name) > 0
    )
    error_message = "resource_aws_ssm_association, output_location.s3_bucket_name is required when output_location is specified."
  }
}

variable "parameters" {
  description = "A block of arbitrary string parameters to pass to the SSM document."
  type        = map(string)
  default     = {}
}

variable "schedule_expression" {
  description = "A cron or rate expression that specifies when the association runs."
  type        = string
  default     = null
}

variable "sync_compliance" {
  description = "The mode for generating association compliance. You can specify AUTO or MANUAL."
  type        = string
  default     = null
  validation {
    condition = var.sync_compliance == null || contains([
      "AUTO", "MANUAL"
    ], var.sync_compliance)
    error_message = "resource_aws_ssm_association, sync_compliance must be either AUTO or MANUAL."
  }
}

variable "tags" {
  description = "A map of tags to assign to the object. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "targets" {
  description = "A block containing the targets of the SSM association. Targets specify what instance IDs or tags to apply the document to. AWS currently supports a maximum of 5 targets."
  type = list(object({
    key    = string
    values = list(string)
  }))
  default = []
  validation {
    condition     = length(var.targets) <= 5
    error_message = "resource_aws_ssm_association, targets supports a maximum of 5 targets."
  }
  validation {
    condition = alltrue([
      for target in var.targets :
      length(target.key) > 0 && length(target.values) > 0
    ])
    error_message = "resource_aws_ssm_association, targets.key and targets.values must not be empty."
  }
}

variable "wait_for_success_timeout_seconds" {
  description = "The number of seconds to wait for the association status to be Success. If Success status is not reached within the given time, create operation will fail."
  type        = number
  default     = null
  validation {
    condition     = var.wait_for_success_timeout_seconds == null || var.wait_for_success_timeout_seconds > 0
    error_message = "resource_aws_ssm_association, wait_for_success_timeout_seconds must be a positive number."
  }
}