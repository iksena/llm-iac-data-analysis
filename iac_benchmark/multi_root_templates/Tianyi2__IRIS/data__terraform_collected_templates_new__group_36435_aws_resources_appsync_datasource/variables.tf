variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "API ID for the GraphQL API for the data source."
  type        = string

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_appsync_datasource, api_id must be a non-empty string."
  }
}

variable "name" {
  description = "User-supplied name for the data source."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_appsync_datasource, name must be a non-empty string."
  }
}

variable "type" {
  description = "Type of the Data Source."
  type        = string

  validation {
    condition = contains([
      "AWS_LAMBDA",
      "AMAZON_DYNAMODB",
      "AMAZON_ELASTICSEARCH",
      "HTTP",
      "NONE",
      "RELATIONAL_DATABASE",
      "AMAZON_EVENTBRIDGE",
      "AMAZON_OPENSEARCH_SERVICE"
    ], var.type)
    error_message = "resource_aws_appsync_datasource, type must be one of: AWS_LAMBDA, AMAZON_DYNAMODB, AMAZON_ELASTICSEARCH, HTTP, NONE, RELATIONAL_DATABASE, AMAZON_EVENTBRIDGE, AMAZON_OPENSEARCH_SERVICE."
  }
}

variable "description" {
  description = "Description of the data source."
  type        = string
  default     = null
}

variable "service_role_arn" {
  description = "IAM service role ARN for the data source. Required if type is specified as AWS_LAMBDA, AMAZON_DYNAMODB, AMAZON_ELASTICSEARCH, AMAZON_EVENTBRIDGE, or AMAZON_OPENSEARCH_SERVICE."
  type        = string
  default     = null

  validation {
    condition     = var.service_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.service_role_arn))
    error_message = "resource_aws_appsync_datasource, service_role_arn must be a valid IAM role ARN."
  }
}

variable "dynamodb_config" {
  description = "DynamoDB settings."
  type = object({
    table_name             = string
    region                 = optional(string)
    use_caller_credentials = optional(bool)
    versioned              = optional(bool)
    delta_sync_config = optional(object({
      base_table_ttl        = optional(number)
      delta_sync_table_name = string
      delta_sync_table_ttl  = optional(number)
    }))
  })
  default = null

  validation {
    condition = var.dynamodb_config == null || (
      var.dynamodb_config.table_name != null &&
      length(var.dynamodb_config.table_name) > 0
    )
    error_message = "resource_aws_appsync_datasource, dynamodb_config.table_name must be a non-empty string when dynamodb_config is specified."
  }

  validation {
    condition = var.dynamodb_config == null || var.dynamodb_config.delta_sync_config == null || (
      var.dynamodb_config.delta_sync_config.delta_sync_table_name != null &&
      length(var.dynamodb_config.delta_sync_config.delta_sync_table_name) > 0
    )
    error_message = "resource_aws_appsync_datasource, dynamodb_config.delta_sync_config.delta_sync_table_name must be a non-empty string when delta_sync_config is specified."
  }
}

variable "elasticsearch_config" {
  description = "Amazon Elasticsearch settings."
  type = object({
    endpoint = string
    region   = optional(string)
  })
  default = null

  validation {
    condition = var.elasticsearch_config == null || (
      var.elasticsearch_config.endpoint != null &&
      length(var.elasticsearch_config.endpoint) > 0
    )
    error_message = "resource_aws_appsync_datasource, elasticsearch_config.endpoint must be a non-empty string when elasticsearch_config is specified."
  }
}

variable "event_bridge_config" {
  description = "AWS EventBridge settings."
  type = object({
    event_bus_arn = string
  })
  default = null

  validation {
    condition = var.event_bridge_config == null || (
      var.event_bridge_config.event_bus_arn != null &&
      can(regex("^arn:aws:events:.+", var.event_bridge_config.event_bus_arn))
    )
    error_message = "resource_aws_appsync_datasource, event_bridge_config.event_bus_arn must be a valid EventBridge ARN when event_bridge_config is specified."
  }
}

variable "http_config" {
  description = "HTTP settings."
  type = object({
    endpoint = string
    authorization_config = optional(object({
      authorization_type = optional(string)
      aws_iam_config = optional(object({
        signing_region       = optional(string)
        signing_service_name = optional(string)
      }))
    }))
  })
  default = null

  validation {
    condition = var.http_config == null || (
      var.http_config.endpoint != null &&
      length(var.http_config.endpoint) > 0
    )
    error_message = "resource_aws_appsync_datasource, http_config.endpoint must be a non-empty string when http_config is specified."
  }

  validation {
    condition     = var.http_config == null || var.http_config.authorization_config == null || var.http_config.authorization_config.authorization_type == null || var.http_config.authorization_config.authorization_type == "AWS_IAM"
    error_message = "resource_aws_appsync_datasource, http_config.authorization_config.authorization_type must be 'AWS_IAM' when specified."
  }
}

variable "lambda_config" {
  description = "AWS Lambda settings."
  type = object({
    function_arn = string
  })
  default = null

  validation {
    condition = var.lambda_config == null || (
      var.lambda_config.function_arn != null &&
      can(regex("^arn:aws:lambda:.+", var.lambda_config.function_arn))
    )
    error_message = "resource_aws_appsync_datasource, lambda_config.function_arn must be a valid Lambda function ARN when lambda_config is specified."
  }
}

variable "opensearchservice_config" {
  description = "Amazon OpenSearch Service settings."
  type = object({
    endpoint = string
    region   = optional(string)
  })
  default = null

  validation {
    condition = var.opensearchservice_config == null || (
      var.opensearchservice_config.endpoint != null &&
      length(var.opensearchservice_config.endpoint) > 0
    )
    error_message = "resource_aws_appsync_datasource, opensearchservice_config.endpoint must be a non-empty string when opensearchservice_config is specified."
  }
}

variable "relational_database_config" {
  description = "AWS RDS settings."
  type = object({
    source_type = optional(string)
    http_endpoint_config = object({
      db_cluster_identifier = string
      aws_secret_store_arn  = string
      database_name         = optional(string)
      region                = optional(string)
      schema                = optional(string)
    })
  })
  default = null

  validation {
    condition     = var.relational_database_config == null || var.relational_database_config.source_type == null || var.relational_database_config.source_type == "RDS_HTTP_ENDPOINT"
    error_message = "resource_aws_appsync_datasource, relational_database_config.source_type must be 'RDS_HTTP_ENDPOINT' when specified."
  }

  validation {
    condition = var.relational_database_config == null || (
      var.relational_database_config.http_endpoint_config.db_cluster_identifier != null &&
      length(var.relational_database_config.http_endpoint_config.db_cluster_identifier) > 0
    )
    error_message = "resource_aws_appsync_datasource, relational_database_config.http_endpoint_config.db_cluster_identifier must be a non-empty string when relational_database_config is specified."
  }

  validation {
    condition = var.relational_database_config == null || (
      var.relational_database_config.http_endpoint_config.aws_secret_store_arn != null &&
      can(regex("^arn:aws:secretsmanager:.+", var.relational_database_config.http_endpoint_config.aws_secret_store_arn))
    )
    error_message = "resource_aws_appsync_datasource, relational_database_config.http_endpoint_config.aws_secret_store_arn must be a valid Secrets Manager ARN when relational_database_config is specified."
  }
}