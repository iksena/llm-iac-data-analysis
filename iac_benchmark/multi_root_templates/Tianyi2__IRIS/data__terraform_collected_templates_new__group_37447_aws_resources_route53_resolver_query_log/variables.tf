variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "destination_arn" {
  description = "The ARN of the resource that you want Route 53 Resolver to send query logs. You can send query logs to an S3 bucket, a CloudWatch Logs log group, or a Kinesis Data Firehose delivery stream."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:[a-z0-9-]+:[a-z0-9-]*:[0-9]+:[a-z0-9-]+", var.destination_arn))
    error_message = "resource_aws_route53_resolver_query_log_config, destination_arn must be a valid AWS ARN."
  }
}

variable "name" {
  description = "The name of the Route 53 Resolver query logging configuration."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_route53_resolver_query_log_config, name must be between 1 and 64 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_.-]+$", var.name))
    error_message = "resource_aws_route53_resolver_query_log_config, name can only contain alphanumeric characters, underscores, periods, and hyphens."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_route53_resolver_query_log_config, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_route53_resolver_query_log_config, tags values must be between 0 and 256 characters."
  }
}