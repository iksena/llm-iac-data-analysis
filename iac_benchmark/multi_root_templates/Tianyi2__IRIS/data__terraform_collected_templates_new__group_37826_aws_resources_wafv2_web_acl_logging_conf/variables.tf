variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "log_destination_configs" {
  description = "Configuration block that allows you to associate Amazon Kinesis Data Firehose, Cloudwatch Log log group, or S3 bucket Amazon Resource Names (ARNs) with the web ACL. Note: data firehose, log group, or bucket name must be prefixed with 'aws-waf-logs-'."
  type        = list(string)

  validation {
    condition = alltrue([
      for arn in var.log_destination_configs : can(regex("aws-waf-logs-", arn))
    ])
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, log_destination_configs: All ARNs must contain 'aws-waf-logs-' prefix in the resource name."
  }
}

variable "logging_filter" {
  description = "Configuration block that specifies which web requests are kept in the logs and which are dropped. It allows filtering based on the rule action and the web request labels applied by matching rules during web ACL evaluation."
  type = object({
    default_behavior = string
    filter = list(object({
      behavior = string
      condition = list(object({
        action_condition = optional(object({
          action = string
        }))
        label_name_condition = optional(object({
          label_name = string
        }))
      }))
      requirement = string
    }))
  })
  default = null

  validation {
    condition     = var.logging_filter == null || contains(["KEEP", "DROP"], var.logging_filter.default_behavior)
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, logging_filter.default_behavior: Must be either 'KEEP' or 'DROP'."
  }

  validation {
    condition = var.logging_filter == null || alltrue([
      for filter in var.logging_filter.filter : contains(["KEEP", "DROP"], filter.behavior)
    ])
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, logging_filter.filter.behavior: Must be either 'KEEP' or 'DROP'."
  }

  validation {
    condition = var.logging_filter == null || alltrue([
      for filter in var.logging_filter.filter : contains(["MEETS_ALL", "MEETS_ANY"], filter.requirement)
    ])
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, logging_filter.filter.requirement: Must be either 'MEETS_ALL' or 'MEETS_ANY'."
  }

  validation {
    condition = var.logging_filter == null || alltrue([
      for filter in var.logging_filter.filter : alltrue([
        for condition in filter.condition : alltrue([
          for action_condition in condition.action_condition != null ? [condition.action_condition] : [] :
          contains(["ALLOW", "BLOCK", "COUNT", "CAPTCHA", "CHALLENGE", "EXCLUDED_AS_COUNT"], action_condition.action)
        ])
      ])
    ])
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, logging_filter.filter.condition.action_condition.action: Must be one of 'ALLOW', 'BLOCK', 'COUNT', 'CAPTCHA', 'CHALLENGE', or 'EXCLUDED_AS_COUNT'."
  }

  validation {
    condition = var.logging_filter == null || alltrue([
      for filter in var.logging_filter.filter : alltrue([
        for condition in filter.condition :
        (condition.action_condition != null && condition.label_name_condition == null) ||
        (condition.action_condition == null && condition.label_name_condition != null)
      ])
    ])
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, logging_filter.filter.condition: Either action_condition or label_name_condition must be specified, but not both."
  }
}

variable "redacted_fields" {
  description = "Configuration for parts of the request that you want to keep out of the logs. Up to 100 redacted_fields blocks are supported."
  type = list(object({
    method       = optional(object({}))
    query_string = optional(object({}))
    single_header = optional(object({
      name = string
    }))
    uri_path = optional(object({}))
  }))
  default = []

  validation {
    condition     = length(var.redacted_fields) <= 100
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, redacted_fields: Maximum of 100 redacted_fields blocks are supported."
  }

  validation {
    condition = alltrue([
      for field in var.redacted_fields :
      (field.method != null ? 1 : 0) +
      (field.query_string != null ? 1 : 0) +
      (field.single_header != null ? 1 : 0) +
      (field.uri_path != null ? 1 : 0) == 1
    ])
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, redacted_fields: You can only specify one of the following: method, query_string, single_header, or uri_path."
  }

  validation {
    condition = alltrue([
      for field in var.redacted_fields :
      field.single_header == null || field.single_header.name == lower(field.single_header.name)
    ])
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, redacted_fields.single_header.name: Must be provided in lowercase characters."
  }
}

variable "resource_arn" {
  description = "Amazon Resource Name (ARN) of the web ACL that you want to associate with log_destination_configs."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:wafv2:", var.resource_arn))
    error_message = "resource_aws_wafv2_web_acl_logging_configuration, resource_arn: Must be a valid WAFv2 Web ACL ARN starting with 'arn:aws:wafv2:'."
  }
}