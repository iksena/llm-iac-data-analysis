variable "knowledge_base_id" {
  description = "Unique identifier of the knowledge base to which the data source belongs"
  type        = string
}

variable "name" {
  description = "Name of the data source"
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "data_deletion_policy" {
  description = "Data deletion policy for a data source"
  type        = string
  default     = null

  validation {
    condition     = var.data_deletion_policy == null || contains(["RETAIN", "DELETE"], var.data_deletion_policy)
    error_message = "resource_aws_bedrockagent_data_source, data_deletion_policy must be one of: RETAIN, DELETE."
  }
}

variable "description" {
  description = "Description of the data source"
  type        = string
  default     = null
}

variable "data_source_configuration" {
  description = "Details about how the data source is stored"
  type = object({
    type = string
    confluence_configuration = optional(object({
      source_configuration = object({
        auth_type              = string
        credentials_secret_arn = string
        host_type              = string
        host_url               = string
      })
      crawler_configuration = optional(object({
        filter_configuration = optional(object({
          type = string
          pattern_object_filter = optional(object({
            filters = list(object({
              object_type       = string
              exclusion_filters = optional(list(string))
              inclusion_filters = optional(list(string))
            }))
          }))
        }))
      }))
    }))
    s3_configuration = optional(object({
      bucket_arn              = string
      bucket_owner_account_id = optional(string)
      inclusion_prefixes      = optional(list(string))
    }))
    salesforce_configuration = optional(object({
      source_configuration = object({
        auth_type              = string
        credentials_secret_arn = string
        host_url               = string
      })
      crawler_configuration = optional(object({
        filter_configuration = optional(object({
          type = string
          pattern_object_filter = optional(object({
            filters = list(object({
              object_type       = string
              exclusion_filters = optional(list(string))
              inclusion_filters = optional(list(string))
            }))
          }))
        }))
      }))
    }))
    share_point_configuration = optional(object({
      source_configuration = object({
        auth_type              = string
        credentials_secret_arn = string
        domain                 = string
        host_type              = string
        site_urls              = list(string)
        tenant_id              = optional(string)
      })
      crawler_configuration = optional(object({
        filter_configuration = optional(object({
          type = string
          pattern_object_filter = optional(object({
            filters = list(object({
              object_type       = string
              exclusion_filters = optional(list(string))
              inclusion_filters = optional(list(string))
            }))
          }))
        }))
      }))
    }))
    web_configuration = optional(object({
      source_configuration = object({
        url_configuration = object({
          seed_urls = optional(list(object({
            url = optional(string)
          })))
        })
      })
      crawler_configuration = optional(object({
        exclusion_filters = optional(list(string))
        inclusion_filters = optional(list(string))
        scope             = optional(string)
        user_agent        = optional(string)
        crawler_limits = optional(object({
          max_pages  = optional(number)
          rate_limit = optional(number)
        }))
      }))
    }))
  })

  validation {
    condition     = contains(["S3", "WEB", "CONFLUENCE", "SALESFORCE", "SHAREPOINT", "CUSTOM", "REDSHIFT_METADATA"], var.data_source_configuration.type)
    error_message = "resource_aws_bedrockagent_data_source, data_source_configuration.type must be one of: S3, WEB, CONFLUENCE, SALESFORCE, SHAREPOINT, CUSTOM, REDSHIFT_METADATA."
  }

  validation {
    condition = var.data_source_configuration.confluence_configuration == null || (
      var.data_source_configuration.confluence_configuration.source_configuration != null &&
      contains(["BASIC", "OAUTH2_CLIENT_CREDENTIALS"], var.data_source_configuration.confluence_configuration.source_configuration.auth_type) &&
      can(regex("^arn:aws(|-cn|-us-gov):secretsmanager:[a-z0-9-]{1,20}:([0-9]{12}|):secret:[a-zA-Z0-9!/_+=.@-]{1,512}$", var.data_source_configuration.confluence_configuration.source_configuration.credentials_secret_arn)) &&
      var.data_source_configuration.confluence_configuration.source_configuration.host_type == "SAAS" &&
      can(regex("^https://[A-Za-z0-9][^\\s]*$", var.data_source_configuration.confluence_configuration.source_configuration.host_url))
    )
    error_message = "resource_aws_bedrockagent_data_source, confluence_configuration validation failed: auth_type must be BASIC or OAUTH2_CLIENT_CREDENTIALS, credentials_secret_arn must match the ARN pattern, host_type must be SAAS, and host_url must match the URL pattern."
  }

  validation {
    condition = var.data_source_configuration.salesforce_configuration == null || (
      var.data_source_configuration.salesforce_configuration.source_configuration != null &&
      var.data_source_configuration.salesforce_configuration.source_configuration.auth_type == "OAUTH2_CLIENT_CREDENTIALS" &&
      can(regex("^arn:aws(|-cn|-us-gov):secretsmanager:[a-z0-9-]{1,20}:([0-9]{12}|):secret:[a-zA-Z0-9!/_+=.@-]{1,512}$", var.data_source_configuration.salesforce_configuration.source_configuration.credentials_secret_arn)) &&
      can(regex("^https://[A-Za-z0-9][^\\s]*$", var.data_source_configuration.salesforce_configuration.source_configuration.host_url))
    )
    error_message = "resource_aws_bedrockagent_data_source, salesforce_configuration validation failed: auth_type must be OAUTH2_CLIENT_CREDENTIALS, credentials_secret_arn must match the ARN pattern, and host_url must match the URL pattern."
  }

  validation {
    condition = var.data_source_configuration.share_point_configuration == null || (
      var.data_source_configuration.share_point_configuration.source_configuration != null &&
      contains(["OAUTH2_CLIENT_CREDENTIALS", "OAUTH2_SHAREPOINT_APP_ONLY_CLIENT_CREDENTIALS"], var.data_source_configuration.share_point_configuration.source_configuration.auth_type) &&
      can(regex("^arn:aws(|-cn|-us-gov):secretsmanager:[a-z0-9-]{1,20}:([0-9]{12}|):secret:[a-zA-Z0-9!/_+=.@-]{1,512}$", var.data_source_configuration.share_point_configuration.source_configuration.credentials_secret_arn)) &&
      var.data_source_configuration.share_point_configuration.source_configuration.host_type == "ONLINE"
    )
    error_message = "resource_aws_bedrockagent_data_source, share_point_configuration validation failed: auth_type must be OAUTH2_CLIENT_CREDENTIALS or OAUTH2_SHAREPOINT_APP_ONLY_CLIENT_CREDENTIALS, credentials_secret_arn must match the ARN pattern, and host_type must be ONLINE."
  }

  validation {
    condition = var.data_source_configuration.web_configuration == null || (
      var.data_source_configuration.web_configuration.source_configuration != null &&
      var.data_source_configuration.web_configuration.source_configuration.url_configuration != null &&
      (var.data_source_configuration.web_configuration.source_configuration.url_configuration.seed_urls == null ||
        alltrue([for seed_url in var.data_source_configuration.web_configuration.source_configuration.url_configuration.seed_urls :
      seed_url.url == null || can(regex("^https?://[A-Za-z0-9][^\\s]*$", seed_url.url))]))
    )
    error_message = "resource_aws_bedrockagent_data_source, web_configuration validation failed: seed_urls.url must match the URL pattern."
  }

  validation {
    condition = var.data_source_configuration.confluence_configuration == null || var.data_source_configuration.confluence_configuration.crawler_configuration == null || var.data_source_configuration.confluence_configuration.crawler_configuration.filter_configuration == null || var.data_source_configuration.confluence_configuration.crawler_configuration.filter_configuration.pattern_object_filter == null || (
      length(var.data_source_configuration.confluence_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters) >= 1 &&
      length(var.data_source_configuration.confluence_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters) <= 25
    )
    error_message = "resource_aws_bedrockagent_data_source, confluence_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters must contain between 1 and 25 filters."
  }

  validation {
    condition = var.data_source_configuration.salesforce_configuration == null || var.data_source_configuration.salesforce_configuration.crawler_configuration == null || var.data_source_configuration.salesforce_configuration.crawler_configuration.filter_configuration == null || var.data_source_configuration.salesforce_configuration.crawler_configuration.filter_configuration.pattern_object_filter == null || (
      length(var.data_source_configuration.salesforce_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters) >= 1 &&
      length(var.data_source_configuration.salesforce_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters) <= 25
    )
    error_message = "resource_aws_bedrockagent_data_source, salesforce_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters must contain between 1 and 25 filters."
  }

  validation {
    condition = var.data_source_configuration.share_point_configuration == null || var.data_source_configuration.share_point_configuration.crawler_configuration == null || var.data_source_configuration.share_point_configuration.crawler_configuration.filter_configuration == null || var.data_source_configuration.share_point_configuration.crawler_configuration.filter_configuration.pattern_object_filter == null || (
      length(var.data_source_configuration.share_point_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters) >= 1 &&
      length(var.data_source_configuration.share_point_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters) <= 25
    )
    error_message = "resource_aws_bedrockagent_data_source, share_point_configuration.crawler_configuration.filter_configuration.pattern_object_filter.filters must contain between 1 and 25 filters."
  }

  validation {
    condition = var.data_source_configuration.web_configuration == null || var.data_source_configuration.web_configuration.crawler_configuration == null || var.data_source_configuration.web_configuration.crawler_configuration.crawler_limits == null || (
      (var.data_source_configuration.web_configuration.crawler_configuration.crawler_limits.max_pages == null || var.data_source_configuration.web_configuration.crawler_configuration.crawler_limits.max_pages <= 25000) &&
      (var.data_source_configuration.web_configuration.crawler_configuration.crawler_limits.rate_limit == null || var.data_source_configuration.web_configuration.crawler_configuration.crawler_limits.rate_limit <= 300)
    )
    error_message = "resource_aws_bedrockagent_data_source, web_configuration.crawler_configuration.crawler_limits validation failed: max_pages must be <= 25000, rate_limit must be <= 300."
  }
}

variable "server_side_encryption_configuration" {
  description = "Details about the configuration of the server-side encryption"
  type = object({
    kms_key_arn = optional(string)
  })
  default = null
}

variable "vector_ingestion_configuration" {
  description = "Details about the configuration of the server-side encryption"
  type = object({
    chunking_configuration = optional(object({
      chunking_strategy = string
      fixed_size_chunking_configuration = optional(object({
        max_tokens         = number
        overlap_percentage = optional(number)
      }))
      hierarchical_chunking_configuration = optional(object({
        level_configuration = list(object({
          max_tokens = number
        }))
        overlap_tokens = number
      }))
      semantic_chunking_configuration = optional(object({
        breakpoint_percentile_threshold = number
        buffer_size                     = number
        max_token                       = number
      }))
    }))
    custom_transformation_configuration = optional(object({
      intermediate_storage = object({
        s3_location = object({
          uri = string
        })
      })
      transformation = object({
        step_to_apply = string
        transformation_function = object({
          transformation_lambda_configuration = object({
            lambda_arn = string
          })
        })
      })
    }))
    parsing_configuration = optional(object({
      parsing_strategy = string
      bedrock_foundation_model_configuration = optional(object({
        model_arn = string
        parsing_prompt = optional(object({
          parsing_prompt_string = string
        }))
      }))
    }))
  })
  default = null

  validation {
    condition     = var.vector_ingestion_configuration == null || var.vector_ingestion_configuration.chunking_configuration == null || contains(["FIXED_SIZE", "HIERARCHICAL", "SEMANTIC", "NONE"], var.vector_ingestion_configuration.chunking_configuration.chunking_strategy)
    error_message = "resource_aws_bedrockagent_data_source, vector_ingestion_configuration.chunking_configuration.chunking_strategy must be one of: FIXED_SIZE, HIERARCHICAL, SEMANTIC, NONE."
  }

  validation {
    condition     = var.vector_ingestion_configuration == null || var.vector_ingestion_configuration.chunking_configuration == null || var.vector_ingestion_configuration.chunking_configuration.chunking_strategy != "FIXED_SIZE" || var.vector_ingestion_configuration.chunking_configuration.fixed_size_chunking_configuration != null
    error_message = "resource_aws_bedrockagent_data_source, vector_ingestion_configuration.chunking_configuration.fixed_size_chunking_configuration is required when chunking_strategy is FIXED_SIZE."
  }

  validation {
    condition     = var.vector_ingestion_configuration == null || var.vector_ingestion_configuration.chunking_configuration == null || var.vector_ingestion_configuration.chunking_configuration.chunking_strategy != "HIERARCHICAL" || var.vector_ingestion_configuration.chunking_configuration.hierarchical_chunking_configuration != null
    error_message = "resource_aws_bedrockagent_data_source, vector_ingestion_configuration.chunking_configuration.hierarchical_chunking_configuration is required when chunking_strategy is HIERARCHICAL."
  }

  validation {
    condition     = var.vector_ingestion_configuration == null || var.vector_ingestion_configuration.chunking_configuration == null || var.vector_ingestion_configuration.chunking_configuration.chunking_strategy != "SEMANTIC" || var.vector_ingestion_configuration.chunking_configuration.semantic_chunking_configuration != null
    error_message = "resource_aws_bedrockagent_data_source, vector_ingestion_configuration.chunking_configuration.semantic_chunking_configuration is required when chunking_strategy is SEMANTIC."
  }

  validation {
    condition     = var.vector_ingestion_configuration == null || var.vector_ingestion_configuration.chunking_configuration == null || var.vector_ingestion_configuration.chunking_configuration.hierarchical_chunking_configuration == null || length(var.vector_ingestion_configuration.chunking_configuration.hierarchical_chunking_configuration.level_configuration) == 2
    error_message = "resource_aws_bedrockagent_data_source, vector_ingestion_configuration.chunking_configuration.hierarchical_chunking_configuration.level_configuration must contain exactly 2 configurations."
  }

  validation {
    condition     = var.vector_ingestion_configuration == null || var.vector_ingestion_configuration.custom_transformation_configuration == null || var.vector_ingestion_configuration.custom_transformation_configuration.transformation.step_to_apply == "POST_CHUNKING"
    error_message = "resource_aws_bedrockagent_data_source, vector_ingestion_configuration.custom_transformation_configuration.transformation.step_to_apply must be POST_CHUNKING."
  }

  validation {
    condition     = var.vector_ingestion_configuration == null || var.vector_ingestion_configuration.parsing_configuration == null || var.vector_ingestion_configuration.parsing_configuration.parsing_strategy == "BEDROCK_FOUNDATION_MODEL"
    error_message = "resource_aws_bedrockagent_data_source, vector_ingestion_configuration.parsing_configuration.parsing_strategy must be BEDROCK_FOUNDATION_MODEL."
  }
}