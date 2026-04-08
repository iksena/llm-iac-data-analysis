variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "database_name" {
  description = "Glue database where results are written."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.database_name))
    error_message = "resource_aws_glue_crawler, database_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "name" {
  description = "Name of the crawler."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_glue_crawler, name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "role" {
  description = "The IAM role friendly name (including path without leading slash), or ARN of an IAM role, used by the crawler to access other resources."
  type        = string

  validation {
    condition     = can(regex("^(arn:aws:iam::[0-9]{12}:role/.+|[a-zA-Z0-9+=,.@_/-]+)$", var.role))
    error_message = "resource_aws_glue_crawler, role must be a valid IAM role name or ARN."
  }
}

variable "classifiers" {
  description = "List of custom classifiers. By default, all AWS classifiers are included in a crawl, but these custom classifiers always override the default classifiers for a given classification."
  type        = list(string)
  default     = []
}

variable "configuration" {
  description = "JSON string of configuration information. For more details see Setting Crawler Configuration Options."
  type        = string
  default     = null

  validation {
    condition     = var.configuration == null || can(jsondecode(var.configuration))
    error_message = "resource_aws_glue_crawler, configuration must be valid JSON."
  }
}

variable "description" {
  description = "Description of the crawler."
  type        = string
  default     = null
}

variable "delta_targets" {
  description = "List of nested Delta Lake target arguments."
  type = list(object({
    connection_name           = optional(string)
    create_native_delta_table = optional(bool)
    delta_tables              = list(string)
    write_manifest            = bool
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.delta_targets : length(target.delta_tables) > 0
    ])
    error_message = "resource_aws_glue_crawler, delta_targets must have at least one delta_table specified."
  }
}

variable "dynamodb_targets" {
  description = "List of nested DynamoDB target arguments."
  type = list(object({
    path      = string
    scan_all  = optional(bool, true)
    scan_rate = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.dynamodb_targets : target.scan_rate == null || (target.scan_rate >= 0.1 && target.scan_rate <= 1.5)
    ])
    error_message = "resource_aws_glue_crawler, dynamodb_targets scan_rate must be between 0.1 and 1.5."
  }
}

variable "jdbc_targets" {
  description = "List of nested JDBC target arguments."
  type = list(object({
    connection_name            = string
    path                       = string
    exclusions                 = optional(list(string))
    enable_additional_metadata = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.jdbc_targets : target.enable_additional_metadata == null || contains(["RAWTYPES", "COMMENTS"], target.enable_additional_metadata)
    ])
    error_message = "resource_aws_glue_crawler, jdbc_targets enable_additional_metadata must be either RAWTYPES or COMMENTS."
  }
}

variable "s3_targets" {
  description = "List of nested Amazon S3 target arguments."
  type = list(object({
    path                = string
    connection_name     = optional(string)
    exclusions          = optional(list(string))
    sample_size         = optional(number)
    event_queue_arn     = optional(string)
    dlq_event_queue_arn = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.s3_targets : target.sample_size == null || (target.sample_size >= 1 && target.sample_size <= 249)
    ])
    error_message = "resource_aws_glue_crawler, s3_targets sample_size must be between 1 and 249."
  }

  validation {
    condition = alltrue([
      for target in var.s3_targets : target.event_queue_arn == null || can(regex("^arn:aws:sqs:", target.event_queue_arn))
    ])
    error_message = "resource_aws_glue_crawler, s3_targets event_queue_arn must be a valid SQS ARN."
  }

  validation {
    condition = alltrue([
      for target in var.s3_targets : target.dlq_event_queue_arn == null || can(regex("^arn:aws:sqs:", target.dlq_event_queue_arn))
    ])
    error_message = "resource_aws_glue_crawler, s3_targets dlq_event_queue_arn must be a valid SQS ARN."
  }
}

variable "catalog_targets" {
  description = "List of nested AWS Glue Data Catalog target arguments."
  type = list(object({
    connection_name     = optional(string)
    database_name       = string
    tables              = list(string)
    event_queue_arn     = optional(string)
    dlq_event_queue_arn = optional(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.catalog_targets : length(target.tables) > 0
    ])
    error_message = "resource_aws_glue_crawler, catalog_targets must have at least one table specified."
  }

  validation {
    condition = alltrue([
      for target in var.catalog_targets : target.event_queue_arn == null || can(regex("^arn:aws:sqs:", target.event_queue_arn))
    ])
    error_message = "resource_aws_glue_crawler, catalog_targets event_queue_arn must be a valid SQS ARN."
  }

  validation {
    condition = alltrue([
      for target in var.catalog_targets : target.dlq_event_queue_arn == null || can(regex("^arn:aws:sqs:", target.dlq_event_queue_arn))
    ])
    error_message = "resource_aws_glue_crawler, catalog_targets dlq_event_queue_arn must be a valid SQS ARN."
  }
}

variable "mongodb_targets" {
  description = "List of nested MongoDB target arguments."
  type = list(object({
    connection_name = string
    path            = string
    scan_all        = optional(bool, true)
  }))
  default = []
}

variable "hudi_targets" {
  description = "List of nested Hudi target arguments."
  type = list(object({
    connection_name         = optional(string)
    paths                   = list(string)
    exclusions              = optional(list(string))
    maximum_traversal_depth = number
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.hudi_targets : target.maximum_traversal_depth >= 1 && target.maximum_traversal_depth <= 20
    ])
    error_message = "resource_aws_glue_crawler, hudi_targets maximum_traversal_depth must be between 1 and 20."
  }

  validation {
    condition = alltrue([
      for target in var.hudi_targets : length(target.paths) > 0
    ])
    error_message = "resource_aws_glue_crawler, hudi_targets must have at least one path specified."
  }
}

variable "iceberg_targets" {
  description = "List of nested Iceberg target arguments."
  type = list(object({
    connection_name         = optional(string)
    paths                   = list(string)
    exclusions              = optional(list(string))
    maximum_traversal_depth = number
  }))
  default = []

  validation {
    condition = alltrue([
      for target in var.iceberg_targets : target.maximum_traversal_depth >= 1 && target.maximum_traversal_depth <= 20
    ])
    error_message = "resource_aws_glue_crawler, iceberg_targets maximum_traversal_depth must be between 1 and 20."
  }

  validation {
    condition = alltrue([
      for target in var.iceberg_targets : length(target.paths) > 0
    ])
    error_message = "resource_aws_glue_crawler, iceberg_targets must have at least one path specified."
  }
}

variable "schedule" {
  description = "A cron expression used to specify the schedule. For more information, see Time-Based Schedules for Jobs and Crawlers. For example, to run something every day at 12:15 UTC, you would specify: cron(15 12 * * ? *)."
  type        = string
  default     = null

  validation {
    condition     = var.schedule == null || can(regex("^cron\\(", var.schedule))
    error_message = "resource_aws_glue_crawler, schedule must be a valid cron expression starting with 'cron('."
  }
}

variable "schema_change_policy" {
  description = "Policy for the crawler's update and deletion behavior."
  type = object({
    delete_behavior = optional(string, "DEPRECATE_IN_DATABASE")
    update_behavior = optional(string, "UPDATE_IN_DATABASE")
  })
  default = null

  validation {
    condition     = var.schema_change_policy == null || contains(["LOG", "DELETE_FROM_DATABASE", "DEPRECATE_IN_DATABASE"], var.schema_change_policy.delete_behavior)
    error_message = "resource_aws_glue_crawler, schema_change_policy delete_behavior must be LOG, DELETE_FROM_DATABASE, or DEPRECATE_IN_DATABASE."
  }

  validation {
    condition     = var.schema_change_policy == null || contains(["LOG", "UPDATE_IN_DATABASE"], var.schema_change_policy.update_behavior)
    error_message = "resource_aws_glue_crawler, schema_change_policy update_behavior must be LOG or UPDATE_IN_DATABASE."
  }
}

variable "lake_formation_configuration" {
  description = "Specifies Lake Formation configuration settings for the crawler."
  type = object({
    account_id                     = optional(string)
    use_lake_formation_credentials = optional(bool)
  })
  default = null

  validation {
    condition     = var.lake_formation_configuration == null || var.lake_formation_configuration.account_id == null || can(regex("^[0-9]{12}$", var.lake_formation_configuration.account_id))
    error_message = "resource_aws_glue_crawler, lake_formation_configuration account_id must be a 12-digit AWS account ID."
  }
}

variable "lineage_configuration" {
  description = "Specifies data lineage configuration settings for the crawler."
  type = object({
    crawler_lineage_settings = optional(string, "DISABLE")
  })
  default = null

  validation {
    condition     = var.lineage_configuration == null || contains(["ENABLE", "DISABLE"], var.lineage_configuration.crawler_lineage_settings)
    error_message = "resource_aws_glue_crawler, lineage_configuration crawler_lineage_settings must be ENABLE or DISABLE."
  }
}

variable "recrawl_policy" {
  description = "A policy that specifies whether to crawl the entire dataset again, or to crawl only folders that were added since the last crawler run."
  type = object({
    recrawl_behavior = optional(string, "CRAWL_EVERYTHING")
  })
  default = null

  validation {
    condition     = var.recrawl_policy == null || contains(["CRAWL_EVENT_MODE", "CRAWL_EVERYTHING", "CRAWL_NEW_FOLDERS_ONLY"], var.recrawl_policy.recrawl_behavior)
    error_message = "resource_aws_glue_crawler, recrawl_policy recrawl_behavior must be CRAWL_EVENT_MODE, CRAWL_EVERYTHING, or CRAWL_NEW_FOLDERS_ONLY."
  }
}

variable "security_configuration" {
  description = "The name of Security Configuration to be used by the crawler"
  type        = string
  default     = null
}

variable "table_prefix" {
  description = "The table prefix used for catalog tables that are created."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}