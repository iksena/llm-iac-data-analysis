variable "authentication_type" {
  description = "Authentication type. Valid values: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA"
  type        = string
  validation {
    condition     = contains(["API_KEY", "AWS_IAM", "AMAZON_COGNITO_USER_POOLS", "OPENID_CONNECT", "AWS_LAMBDA"], var.authentication_type)
    error_message = "resource_aws_appsync_graphql_api, authentication_type must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }
}

variable "name" {
  description = "User-supplied name for the GraphQL API."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "additional_authentication_provider" {
  description = "One or more additional authentication providers for the GraphQL API."
  type = object({
    authentication_type = string
    openid_connect_config = optional(object({
      issuer    = string
      auth_ttl  = optional(number)
      client_id = optional(string)
      iat_ttl   = optional(number)
    }))
    user_pool_config = optional(object({
      default_action      = optional(string)
      user_pool_id        = string
      app_id_client_regex = optional(string)
      aws_region          = optional(string)
    }))
  })
  default = null
  validation {
    condition     = var.additional_authentication_provider == null || contains(["API_KEY", "AWS_IAM", "AMAZON_COGNITO_USER_POOLS", "OPENID_CONNECT", "AWS_LAMBDA"], var.additional_authentication_provider.authentication_type)
    error_message = "resource_aws_appsync_graphql_api, authentication_type in additional_authentication_provider must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }
  validation {
    condition     = var.additional_authentication_provider == null || var.additional_authentication_provider.user_pool_config == null || var.additional_authentication_provider.user_pool_config.default_action == null || contains(["ALLOW", "DENY"], var.additional_authentication_provider.user_pool_config.default_action)
    error_message = "resource_aws_appsync_graphql_api, default_action in additional_authentication_provider.user_pool_config must be one of: ALLOW, DENY."
  }
}

variable "api_type" {
  description = "API type. Valid values are GRAPHQL or MERGED. A MERGED type requires merged_api_execution_role_arn to be set."
  type        = string
  default     = null
  validation {
    condition     = var.api_type == null || contains(["GRAPHQL", "MERGED"], var.api_type)
    error_message = "resource_aws_appsync_graphql_api, api_type must be one of: GRAPHQL, MERGED."
  }
}

variable "enhanced_metrics_config" {
  description = "Enables and controls the enhanced metrics feature."
  type = object({
    data_source_level_metrics_behavior = optional(string)
    operation_level_metrics_config     = optional(string)
    resolver_level_metrics_behavior    = optional(string)
  })
  default = null
  validation {
    condition     = var.enhanced_metrics_config == null || var.enhanced_metrics_config.data_source_level_metrics_behavior == null || contains(["FULL_REQUEST_DATA_SOURCE_METRICS", "PER_DATA_SOURCE_METRICS"], var.enhanced_metrics_config.data_source_level_metrics_behavior)
    error_message = "resource_aws_appsync_graphql_api, data_source_level_metrics_behavior in enhanced_metrics_config must be one of: FULL_REQUEST_DATA_SOURCE_METRICS, PER_DATA_SOURCE_METRICS."
  }
  validation {
    condition     = var.enhanced_metrics_config == null || var.enhanced_metrics_config.operation_level_metrics_config == null || contains(["ENABLED", "DISABLED"], var.enhanced_metrics_config.operation_level_metrics_config)
    error_message = "resource_aws_appsync_graphql_api, operation_level_metrics_config in enhanced_metrics_config must be one of: ENABLED, DISABLED."
  }
  validation {
    condition     = var.enhanced_metrics_config == null || var.enhanced_metrics_config.resolver_level_metrics_behavior == null || contains(["FULL_REQUEST_RESOLVER_METRICS", "PER_RESOLVER_METRICS"], var.enhanced_metrics_config.resolver_level_metrics_behavior)
    error_message = "resource_aws_appsync_graphql_api, resolver_level_metrics_behavior in enhanced_metrics_config must be one of: FULL_REQUEST_RESOLVER_METRICS, PER_RESOLVER_METRICS."
  }
}

variable "introspection_config" {
  description = "Sets the value of the GraphQL API to enable (ENABLED) or disable (DISABLED) introspection. If no value is provided, the introspection configuration will be set to ENABLED by default."
  type        = string
  default     = null
  validation {
    condition     = var.introspection_config == null || contains(["ENABLED", "DISABLED"], var.introspection_config)
    error_message = "resource_aws_appsync_graphql_api, introspection_config must be one of: ENABLED, DISABLED."
  }
}

variable "lambda_authorizer_config" {
  description = "Nested argument containing Lambda authorizer configuration."
  type = object({
    authorizer_uri                   = string
    authorizer_result_ttl_in_seconds = optional(number)
    identity_validation_expression   = optional(string)
  })
  default = null
  validation {
    condition     = var.lambda_authorizer_config == null || var.lambda_authorizer_config.authorizer_result_ttl_in_seconds == null || (var.lambda_authorizer_config.authorizer_result_ttl_in_seconds >= 0 && var.lambda_authorizer_config.authorizer_result_ttl_in_seconds <= 3600)
    error_message = "resource_aws_appsync_graphql_api, authorizer_result_ttl_in_seconds in lambda_authorizer_config must be between 0 and 3600."
  }
}

variable "log_config" {
  description = "Nested argument containing logging configuration."
  type = object({
    cloudwatch_logs_role_arn = string
    field_log_level          = string
    exclude_verbose_content  = optional(bool)
  })
  default = null
  validation {
    condition     = var.log_config == null || contains(["ALL", "ERROR", "NONE"], var.log_config.field_log_level)
    error_message = "resource_aws_appsync_graphql_api, field_log_level in log_config must be one of: ALL, ERROR, NONE."
  }
}

variable "merged_api_execution_role_arn" {
  description = "ARN of the execution role when api_type is set to MERGED."
  type        = string
  default     = null
}

variable "openid_connect_config" {
  description = "Nested argument containing OpenID Connect configuration."
  type = object({
    issuer    = string
    auth_ttl  = optional(number)
    client_id = optional(string)
    iat_ttl   = optional(number)
  })
  default = null
}

variable "query_depth_limit" {
  description = "The maximum depth a query can have in a single request. The default value is 0 (or unspecified), which indicates there's no depth limit. If you set a limit, it can be between 1 and 75 nested levels."
  type        = number
  default     = null
  validation {
    condition     = var.query_depth_limit == null || (var.query_depth_limit >= 0 && var.query_depth_limit <= 75)
    error_message = "resource_aws_appsync_graphql_api, query_depth_limit must be between 0 and 75."
  }
}

variable "resolver_count_limit" {
  description = "The maximum number of resolvers that can be invoked in a single request. The default value is 0 (or unspecified), which will set the limit to 10000. When specified, the limit value can be between 1 and 10000."
  type        = number
  default     = null
  validation {
    condition     = var.resolver_count_limit == null || (var.resolver_count_limit >= 0 && var.resolver_count_limit <= 10000)
    error_message = "resource_aws_appsync_graphql_api, resolver_count_limit must be between 0 and 10000."
  }
}

variable "schema" {
  description = "Schema definition, in GraphQL schema language format. Terraform cannot perform drift detection of this configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "user_pool_config" {
  description = "Amazon Cognito User Pool configuration."
  type = object({
    default_action      = optional(string)
    user_pool_id        = string
    app_id_client_regex = optional(string)
    aws_region          = optional(string)
  })
  default = null
  validation {
    condition     = var.user_pool_config == null || var.user_pool_config.default_action == null || contains(["ALLOW", "DENY"], var.user_pool_config.default_action)
    error_message = "resource_aws_appsync_graphql_api, default_action in user_pool_config must be one of: ALLOW, DENY."
  }
}

variable "visibility" {
  description = "Sets the value of the GraphQL API to public (GLOBAL) or private (PRIVATE). If no value is provided, the visibility will be set to GLOBAL by default. This value cannot be changed once the API has been created."
  type        = string
  default     = null
  validation {
    condition     = var.visibility == null || contains(["GLOBAL", "PRIVATE"], var.visibility)
    error_message = "resource_aws_appsync_graphql_api, visibility must be one of: GLOBAL, PRIVATE."
  }
}

variable "xray_enabled" {
  description = "Whether tracing with X-ray is enabled. Defaults to false."
  type        = bool
  default     = false
}