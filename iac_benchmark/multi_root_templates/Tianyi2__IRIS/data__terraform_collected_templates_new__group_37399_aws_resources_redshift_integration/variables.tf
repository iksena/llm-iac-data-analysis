variable "integration_name" {
  description = "Name of the integration."
  type        = string

  validation {
    condition     = length(var.integration_name) > 0
    error_message = "resource_aws_redshift_integration, integration_name must not be empty."
  }
}

variable "source_arn" {
  description = "ARN of the database to use as the source for replication. You can specify a DynamoDB table or an S3 bucket."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:(dynamodb|s3):", var.source_arn))
    error_message = "resource_aws_redshift_integration, source_arn must be a valid DynamoDB table or S3 bucket ARN."
  }
}

variable "target_arn" {
  description = "ARN of the Redshift data warehouse to use as the target for replication."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:redshift:", var.target_arn))
    error_message = "resource_aws_redshift_integration, target_arn must be a valid Redshift ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_redshift_integration, region must be a valid AWS region identifier."
  }
}

variable "additional_encryption_context" {
  description = "Set of non-secret key–value pairs that contains additional contextual information about the data. You can only include this parameter if you specify the kms_key_id parameter."
  type        = map(string)
  default     = null
}

variable "description" {
  description = "Description of the integration."
  type        = string
  default     = null
}

variable "kms_key_id" {
  description = "KMS key identifier for the key to use to encrypt the integration. If you don't specify an encryption key, Redshift uses a default AWS owned key. You can only include this parameter if source_arn references a DynamoDB table."
  type        = string
  default     = null

  validation {
    condition     = var.kms_key_id == null || can(regex("^(arn:aws:kms:|alias/|[a-f0-9-]{36})", var.kms_key_id))
    error_message = "resource_aws_redshift_integration, kms_key_id must be a valid KMS key ARN, alias, or key ID."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default = null

  validation {
    condition = var.timeouts == null || alltrue([
      for timeout in values(var.timeouts) : timeout == null || can(regex("^[0-9]+[smh]$", timeout))
    ])
    error_message = "resource_aws_redshift_integration, timeouts must be valid duration strings (e.g., '30m', '1h')."
  }
}