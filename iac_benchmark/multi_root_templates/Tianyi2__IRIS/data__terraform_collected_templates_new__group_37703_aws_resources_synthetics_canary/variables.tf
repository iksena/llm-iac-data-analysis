variable "artifact_s3_location" {
  description = "Location in Amazon S3 where Synthetics stores artifacts from the test runs of this canary"
  type        = string

  validation {
    condition     = can(regex("^s3://[a-z0-9.-]+(/.*)?$", var.artifact_s3_location))
    error_message = "resource_aws_synthetics_canary, artifact_s3_location must be a valid S3 location starting with 's3://'."
  }
}

variable "execution_role_arn" {
  description = "ARN of the IAM role to be used to run the canary"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/", var.execution_role_arn))
    error_message = "resource_aws_synthetics_canary, execution_role_arn must be a valid IAM role ARN."
  }
}

variable "handler" {
  description = "Entry point to use for the source code when running the canary. This value must end with the string '.handler'"
  type        = string

  validation {
    condition     = can(regex("\\.handler$", var.handler))
    error_message = "resource_aws_synthetics_canary, handler must end with '.handler'."
  }
}

variable "name" {
  description = "Name for this canary. Has a maximum length of 255 characters. Valid characters are lowercase alphanumeric, hyphen, or underscore"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9_-]+$", var.name)) && length(var.name) <= 255 && length(var.name) > 0
    error_message = "resource_aws_synthetics_canary, name must contain only lowercase alphanumeric characters, hyphens, or underscores and be between 1 and 255 characters long."
  }
}

variable "runtime_version" {
  description = "Runtime version to use for the canary. Values include syn-python-selenium-1.0, syn-nodejs-puppeteer-3.0, syn-nodejs-2.2, syn-nodejs-2.1, syn-nodejs-2.0, and syn-1.0"
  type        = string

  validation {
    condition = contains([
      "syn-python-selenium-1.0",
      "syn-nodejs-puppeteer-3.0",
      "syn-nodejs-2.2",
      "syn-nodejs-2.1",
      "syn-nodejs-2.0",
      "syn-1.0"
    ], var.runtime_version)
    error_message = "resource_aws_synthetics_canary, runtime_version must be one of: syn-python-selenium-1.0, syn-nodejs-puppeteer-3.0, syn-nodejs-2.2, syn-nodejs-2.1, syn-nodejs-2.0, syn-1.0."
  }
}

variable "schedule" {
  description = "Configuration block providing how often the canary is to run and when these test runs are to stop"
  type = object({
    expression          = string
    duration_in_seconds = optional(number)
    retry_config = optional(object({
      max_retries = number
    }))
  })

  validation {
    condition     = can(regex("^(rate\\(\\d+ (minute|minutes|hour)\\)|cron\\(.+\\))$", var.schedule.expression))
    error_message = "resource_aws_synthetics_canary, schedule.expression must be a valid rate expression like 'rate(5 minutes)' or cron expression like 'cron(0 10 * * ? *)'."
  }

  validation {
    condition = var.schedule.retry_config == null || (
      var.schedule.retry_config.max_retries >= 0 && 
      var.schedule.retry_config.max_retries <= 2
    )
    error_message = "resource_aws_synthetics_canary, schedule.retry_config.max_retries must be between 0 and 2."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "delete_lambda" {
  description = "Specifies whether to also delete the Lambda functions and layers used by this canary"
  type        = bool
  default     = false
}

variable "vpc_config" {
  description = "Configuration block for VPC settings"
  type = object({
    subnet_ids                  = list(string)
    security_group_ids          = list(string)
    ipv6_allowed_for_dual_stack = optional(bool, false)
  })
  default = null

  validation {
    condition = var.vpc_config == null || (
      length(var.vpc_config.subnet_ids) > 0 &&
      length(var.vpc_config.security_group_ids) > 0
    )
    error_message = "resource_aws_synthetics_canary, vpc_config.subnet_ids and vpc_config.security_group_ids are required when vpc_config is specified."
  }
}

variable "failure_retention_period" {
  description = "Number of days to retain data about failed runs of this canary. Valid range is 1 to 455 days"
  type        = number
  default     = null

  validation {
    condition     = var.failure_retention_period == null || (var.failure_retention_period >= 1 && var.failure_retention_period <= 455)
    error_message = "resource_aws_synthetics_canary, failure_retention_period must be between 1 and 455 days."
  }
}

variable "run_config" {
  description = "Configuration block for individual canary runs"
  type = object({
    timeout_in_seconds    = optional(number)
    memory_in_mb          = optional(number)
    active_tracing        = optional(bool)
    environment_variables = optional(map(string))
    ephemeral_storage     = optional(number)
  })
  default = null

  validation {
    condition = var.run_config == null || var.run_config.memory_in_mb == null || (
      var.run_config.memory_in_mb % 64 == 0 && var.run_config.memory_in_mb > 0
    )
    error_message = "resource_aws_synthetics_canary, run_config.memory_in_mb must be a positive multiple of 64."
  }

  validation {
    condition = var.run_config == null || var.run_config.timeout_in_seconds == null || (
      var.run_config.timeout_in_seconds > 0 && var.run_config.timeout_in_seconds <= 840
    )
    error_message = "resource_aws_synthetics_canary, run_config.timeout_in_seconds must be between 1 and 840 seconds (14 minutes)."
  }

  validation {
    condition = var.run_config == null || var.run_config.ephemeral_storage == null || (
      var.run_config.ephemeral_storage >= 512 && var.run_config.ephemeral_storage <= 10240
    )
    error_message = "resource_aws_synthetics_canary, run_config.ephemeral_storage must be between 512 and 10240 MB."
  }
}

variable "s3_bucket" {
  description = "Full bucket name which is used if your canary script is located in S3. Conflicts with zip_file"
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of your script. Conflicts with zip_file"
  type        = string
  default     = null
}

variable "s3_version" {
  description = "S3 version ID of your script. Conflicts with zip_file"
  type        = string
  default     = null
}

variable "start_canary" {
  description = "Whether to run or stop the canary"
  type        = bool
  default     = null
}

variable "success_retention_period" {
  description = "Number of days to retain data about successful runs of this canary. Valid range is 1 to 455 days"
  type        = number
  default     = null

  validation {
    condition     = var.success_retention_period == null || (var.success_retention_period >= 1 && var.success_retention_period <= 455)
    error_message = "resource_aws_synthetics_canary, success_retention_period must be between 1 and 455 days."
  }
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "artifact_config" {
  description = "Configuration for canary artifacts, including the encryption-at-rest settings for artifacts that the canary uploads to Amazon S3"
  type = object({
    s3_encryption = optional(object({
      encryption_mode = optional(string)
      kms_key_arn     = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.artifact_config == null || var.artifact_config.s3_encryption == null || (
      var.artifact_config.s3_encryption.encryption_mode == null ||
      contains(["SSE_S3", "SSE_KMS"], var.artifact_config.s3_encryption.encryption_mode)
    )
    error_message = "resource_aws_synthetics_canary, artifact_config.s3_encryption.encryption_mode must be either 'SSE_S3' or 'SSE_KMS'."
  }

  validation {
    condition = var.artifact_config == null || var.artifact_config.s3_encryption == null || (
      var.artifact_config.s3_encryption.encryption_mode != "SSE_KMS" ||
      var.artifact_config.s3_encryption.kms_key_arn != null
    )
    error_message = "resource_aws_synthetics_canary, artifact_config.s3_encryption.kms_key_arn is required when encryption_mode is 'SSE_KMS'."
  }
}

variable "zip_file" {
  description = "ZIP file that contains the script. It can be up to 225KB. Conflicts with s3_bucket, s3_key, and s3_version"
  type        = string
  default     = null
}

locals {
  # Cross-validation: when schedule.retry_config.max_retries is 2, run_config.timeout_in_seconds should be less than 600
  validate_retry_timeout = (
    var.schedule.retry_config == null ||
    var.schedule.retry_config.max_retries != 2 ||
    var.run_config == null ||
    var.run_config.timeout_in_seconds == null ||
    var.run_config.timeout_in_seconds < 600
  ) ? true : tobool("ERROR: resource_aws_synthetics_canary, when schedule.retry_config.max_retries is 2, run_config.timeout_in_seconds must be less than 600 seconds.")

  # Cross-validation: zip_file conflicts with s3_bucket, s3_key, and s3_version
  validate_zip_s3_conflict = (
    var.zip_file == null || (
      var.s3_bucket == null && 
      var.s3_key == null && 
      var.s3_version == null
    )
  ) ? true : tobool("ERROR: resource_aws_synthetics_canary, zip_file conflicts with s3_bucket, s3_key, and s3_version.")
}