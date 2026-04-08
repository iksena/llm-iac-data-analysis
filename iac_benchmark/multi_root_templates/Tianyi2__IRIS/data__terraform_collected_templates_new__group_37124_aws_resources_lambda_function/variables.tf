# Required variables
variable "function_name" {
  description = "Unique name for your Lambda Function."
  type        = string

  validation {
    condition     = length(var.function_name) > 0 && length(var.function_name) <= 64
    error_message = "resource_aws_lambda_function, function_name must be between 1 and 64 characters."
  }
}

variable "role" {
  description = "ARN of the function's execution role. The role provides the function's identity and access to AWS services and resources."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role))
    error_message = "resource_aws_lambda_function, role must be a valid IAM role ARN."
  }
}

# Optional variables - Deployment package configuration
variable "filename" {
  description = "Path to the function's deployment package within the local filesystem. Conflicts with image_uri and s3_bucket."
  type        = string
  default     = null
}

variable "s3_bucket" {
  description = "S3 bucket location containing the function's deployment package. Conflicts with filename and image_uri."
  type        = string
  default     = null
}

variable "s3_key" {
  description = "S3 key of an object containing the function's deployment package. Required if s3_bucket is set."
  type        = string
  default     = null
}

variable "s3_object_version" {
  description = "Object version containing the function's deployment package. Conflicts with filename and image_uri."
  type        = string
  default     = null
}

variable "image_uri" {
  description = "ECR image URI containing the function's deployment package. Conflicts with filename and s3_bucket."
  type        = string
  default     = null
}

variable "source_code_hash" {
  description = "Base64-encoded SHA256 hash of the package file. Used to trigger updates when source code changes."
  type        = string
  default     = null
}

variable "source_kms_key_arn" {
  description = "ARN of the AWS Key Management Service key used to encrypt the function's .zip deployment package. Conflicts with image_uri."
  type        = string
  default     = null

  validation {
    condition     = var.source_kms_key_arn == null || can(regex("^arn:aws:kms:", var.source_kms_key_arn))
    error_message = "resource_aws_lambda_function, source_kms_key_arn must be a valid KMS key ARN."
  }
}

# Function configuration variables
variable "package_type" {
  description = "Lambda deployment package type. Valid values are Zip and Image."
  type        = string
  default     = "Zip"

  validation {
    condition     = contains(["Zip", "Image"], var.package_type)
    error_message = "resource_aws_lambda_function, package_type must be either 'Zip' or 'Image'."
  }
}

variable "runtime" {
  description = "Identifier of the function's runtime. Required if package_type is Zip."
  type        = string
  default     = null

  validation {
    condition = var.runtime == null || contains([
      "nodejs20.x", "nodejs18.x", "nodejs16.x", "nodejs14.x", "nodejs12.x",
      "python3.12", "python3.11", "python3.10", "python3.9", "python3.8",
      "java21", "java17", "java11", "java8", "java8.al2",
      "dotnet8", "dotnet6",
      "go1.x",
      "ruby3.2", "ruby2.7",
      "provided.al2023", "provided.al2", "provided"
    ], var.runtime)
    error_message = "resource_aws_lambda_function, runtime must be a valid Lambda runtime identifier."
  }
}

variable "handler" {
  description = "Function entry point in your code. Required if package_type is Zip."
  type        = string
  default     = null
}

variable "architectures" {
  description = "Instruction set architecture for your Lambda function. Valid values are [\"x86_64\"] and [\"arm64\"]."
  type        = list(string)
  default     = ["x86_64"]

  validation {
    condition     = length(var.architectures) == 1 && contains(["x86_64", "arm64"], var.architectures[0])
    error_message = "resource_aws_lambda_function, architectures must contain exactly one value: either 'x86_64' or 'arm64'."
  }
}

variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime. Valid value between 128 MB to 10,240 MB (10 GB), in 1 MB increments."
  type        = number
  default     = 128

  validation {
    condition     = var.memory_size >= 128 && var.memory_size <= 10240
    error_message = "resource_aws_lambda_function, memory_size must be between 128 and 10240 MB."
  }
}

variable "timeout" {
  description = "Amount of time your Lambda Function has to run in seconds. Valid between 1 and 900."
  type        = number
  default     = 3

  validation {
    condition     = var.timeout >= 1 && var.timeout <= 900
    error_message = "resource_aws_lambda_function, timeout must be between 1 and 900 seconds."
  }
}

variable "description" {
  description = "Description of what your Lambda Function does."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 256
    error_message = "resource_aws_lambda_function, description must not exceed 256 characters."
  }
}

variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function."
  type        = list(string)
  default     = null

  validation {
    condition     = var.layers == null || length(var.layers) <= 5
    error_message = "resource_aws_lambda_function, layers can contain a maximum of 5 layer ARNs."
  }
}

variable "reserved_concurrent_executions" {
  description = "Amount of reserved concurrent executions for this lambda function. A value of 0 disables lambda from being triggered and -1 removes any concurrency limitations."
  type        = number
  default     = -1

  validation {
    condition     = var.reserved_concurrent_executions >= -1
    error_message = "resource_aws_lambda_function, reserved_concurrent_executions must be -1 or greater."
  }
}

variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version."
  type        = bool
  default     = false
}

variable "region" {
  description = "Region where this resource will be managed."
  type        = string
  default     = null
}

variable "skip_destroy" {
  description = "Whether to retain the old version of a previously deployed Lambda Layer."
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "ARN of the AWS Key Management Service key used to encrypt environment variables."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_arn == null || can(regex("^arn:aws:kms:", var.kms_key_arn))
    error_message = "resource_aws_lambda_function, kms_key_arn must be a valid KMS key ARN."
  }
}

variable "code_signing_config_arn" {
  description = "ARN of a code-signing configuration to enable code signing for this function."
  type        = string
  default     = null

  validation {
    condition     = var.code_signing_config_arn == null || can(regex("^arn:aws:lambda:", var.code_signing_config_arn))
    error_message = "resource_aws_lambda_function, code_signing_config_arn must be a valid code signing configuration ARN."
  }
}

variable "replace_security_groups_on_destroy" {
  description = "Whether to replace the security groups on the function's VPC configuration prior to destruction."
  type        = bool
  default     = false
}

variable "replacement_security_group_ids" {
  description = "List of security group IDs to assign to the function's VPC configuration prior to destruction. Required if replace_security_groups_on_destroy is true."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Key-value map of tags for the Lambda function."
  type        = map(string)
  default     = {}
}

# Configuration block variables
variable "dead_letter_config" {
  description = "Configuration for dead letter queue."
  type = object({
    target_arn = string
  })
  default = null

  validation {
    condition     = var.dead_letter_config == null || can(regex("^arn:aws:(sns|sqs):", var.dead_letter_config.target_arn))
    error_message = "resource_aws_lambda_function, dead_letter_config.target_arn must be a valid SNS topic or SQS queue ARN."
  }
}

variable "environment" {
  description = "Configuration for environment variables."
  type = object({
    variables = map(string)
  })
  default = null
}

variable "ephemeral_storage" {
  description = "Configuration for ephemeral storage (/tmp)."
  type = object({
    size = number
  })
  default = null

  validation {
    condition     = var.ephemeral_storage == null || (var.ephemeral_storage.size >= 512 && var.ephemeral_storage.size <= 10240)
    error_message = "resource_aws_lambda_function, ephemeral_storage.size must be between 512 MB and 10,240 MB (10 GB)."
  }
}

variable "file_system_config" {
  description = "Configuration for EFS file system."
  type = object({
    arn              = string
    local_mount_path = string
  })
  default = null

  validation {
    condition     = var.file_system_config == null || can(regex("^arn:aws:elasticfilesystem:", var.file_system_config.arn))
    error_message = "resource_aws_lambda_function, file_system_config.arn must be a valid EFS access point ARN."
  }

  validation {
    condition     = var.file_system_config == null || startswith(var.file_system_config.local_mount_path, "/mnt/")
    error_message = "resource_aws_lambda_function, file_system_config.local_mount_path must start with '/mnt/'."
  }
}

variable "image_config" {
  description = "Configuration for container image."
  type = object({
    command           = optional(list(string))
    entry_point       = optional(list(string))
    working_directory = optional(string)
  })
  default = null
}

variable "logging_config" {
  description = "Configuration for advanced logging settings."
  type = object({
    log_format            = string
    application_log_level = optional(string)
    system_log_level      = optional(string)
    log_group             = optional(string)
  })
  default = null

  validation {
    condition     = var.logging_config == null || contains(["Text", "JSON"], var.logging_config.log_format)
    error_message = "resource_aws_lambda_function, logging_config.log_format must be either 'Text' or 'JSON'."
  }

  validation {
    condition     = var.logging_config == null || var.logging_config.application_log_level == null || contains(["TRACE", "DEBUG", "INFO", "WARN", "ERROR", "FATAL"], var.logging_config.application_log_level)
    error_message = "resource_aws_lambda_function, logging_config.application_log_level must be one of: TRACE, DEBUG, INFO, WARN, ERROR, FATAL."
  }

  validation {
    condition     = var.logging_config == null || var.logging_config.system_log_level == null || contains(["DEBUG", "INFO", "WARN"], var.logging_config.system_log_level)
    error_message = "resource_aws_lambda_function, logging_config.system_log_level must be one of: DEBUG, INFO, WARN."
  }
}

variable "snap_start" {
  description = "Configuration for snap start settings."
  type = object({
    apply_on = string
  })
  default = null

  validation {
    condition     = var.snap_start == null || var.snap_start.apply_on == "PublishedVersions"
    error_message = "resource_aws_lambda_function, snap_start.apply_on must be 'PublishedVersions'."
  }
}

variable "tracing_config" {
  description = "Configuration for X-Ray tracing."
  type = object({
    mode = string
  })
  default = null

  validation {
    condition     = var.tracing_config == null || contains(["Active", "PassThrough"], var.tracing_config.mode)
    error_message = "resource_aws_lambda_function, tracing_config.mode must be either 'Active' or 'PassThrough'."
  }
}

variable "vpc_config" {
  description = "Configuration for VPC."
  type = object({
    subnet_ids                  = list(string)
    security_group_ids          = list(string)
    ipv6_allowed_for_dual_stack = optional(bool, false)
  })
  default = null

  validation {
    condition     = var.vpc_config == null || length(var.vpc_config.subnet_ids) > 0
    error_message = "resource_aws_lambda_function, vpc_config.subnet_ids must contain at least one subnet ID."
  }

  validation {
    condition     = var.vpc_config == null || length(var.vpc_config.security_group_ids) > 0
    error_message = "resource_aws_lambda_function, vpc_config.security_group_ids must contain at least one security group ID."
  }
}

variable "timeouts" {
  description = "Configuration for resource timeouts."
  type = object({
    create = optional(string, "10m")
    update = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    update = "10m"
    delete = "10m"
  }
}