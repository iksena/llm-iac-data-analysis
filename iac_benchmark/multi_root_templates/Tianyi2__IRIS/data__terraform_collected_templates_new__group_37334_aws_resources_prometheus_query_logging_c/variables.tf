variable "workspace_id" {
  description = "The ID of the AMP workspace for which to configure query logging"
  type        = string

  validation {
    condition     = can(regex("^ws-[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$", var.workspace_id))
    error_message = "resource_aws_prometheus_query_logging_configuration, workspace_id must be a valid AMP workspace ID format (ws-xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)."
  }
}

variable "destination" {
  description = "Configuration block for the logging destinations"
  type = object({
    cloudwatch_logs = object({
      log_group_arn = string
    })
    filters = object({
      qsp_threshold = number
    })
  })

  validation {
    condition     = can(regex("^arn:aws:logs:[a-z0-9-]+:[0-9]{12}:log-group:", var.destination.cloudwatch_logs.log_group_arn))
    error_message = "resource_aws_prometheus_query_logging_configuration, log_group_arn must be a valid CloudWatch log group ARN."
  }

  validation {
    condition     = var.destination.filters.qsp_threshold > 0
    error_message = "resource_aws_prometheus_query_logging_configuration, qsp_threshold must be greater than 0."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_prometheus_query_logging_configuration, region must be a valid AWS region identifier."
  }
}