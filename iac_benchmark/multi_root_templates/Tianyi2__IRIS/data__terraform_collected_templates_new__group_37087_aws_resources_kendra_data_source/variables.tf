variable "index_id" {
  description = "(Required, Forces new resource) The identifier of the index for your Amazon Kendra data source."
  type        = string

  validation {
    condition     = length(var.index_id) > 0
    error_message = "resource_aws_kendra_data_source, index_id must be a non-empty string."
  }
}

variable "name" {
  description = "(Required) A name for your data source connector."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_kendra_data_source, name must be a non-empty string."
  }
}

variable "role_arn" {
  description = "(Required, Optional in one scenario) The Amazon Resource Name (ARN) of a role with permission to access the data source connector. You can't specify the role_arn parameter when the type parameter is set to CUSTOM. The role_arn parameter is required for all other data sources."
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.role_arn))
    error_message = "resource_aws_kendra_data_source, role_arn must be a valid IAM role ARN format."
  }
}

variable "type" {
  description = "(Required, Forces new resource) The type of data source repository. For an updated list of values, refer to Valid Values for Type."
  type        = string

  validation {
    condition = contains([
      "CUSTOM", "S3", "WEBCRAWLER", "TEMPLATE", "SHAREPOINT", "ONEDRIVE",
      "SERVICENOW", "SALESFORCE", "CONFLUENCE", "GOOGLEDRIVE", "BOX",
      "WORKDOCS", "FSX", "SLACK", "JIRA", "GITHUB", "ALFRESCO"
    ], var.type)
    error_message = "resource_aws_kendra_data_source, type must be a valid data source type."
  }
}

variable "region" {
  description = "(Optional) Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "(Optional) A description for the Data Source connector."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1000
    error_message = "resource_aws_kendra_data_source, description must be 1000 characters or less."
  }
}

variable "language_code" {
  description = "(Optional) The code for a language. This allows you to support a language for all documents when creating the Data Source connector."
  type        = string
  default     = null

  validation {
    condition = var.language_code == null || contains([
      "ar", "hy", "bn", "bg", "ca", "zh", "zh-TW", "hr", "cs", "da", "nl", "en",
      "et", "fi", "fr", "gl", "de", "el", "gu", "he", "hi", "hu", "is", "id",
      "ga", "it", "ja", "kn", "ko", "lv", "lt", "ms", "ml", "mr", "no", "fa",
      "pl", "pt", "pa", "ro", "ru", "sr", "si", "sk", "sl", "es", "sv", "ta",
      "te", "tr", "uk", "ur", "vi", "cy"
    ], var.language_code)
    error_message = "resource_aws_kendra_data_source, language_code must be a valid ISO 639-1 language code."
  }
}

variable "schedule" {
  description = "(Optional) Sets the frequency for Amazon Kendra to check the documents in your Data Source repository and update the index."
  type        = string
  default     = null

  validation {
    condition     = var.schedule == null || can(regex("^cron\\(.*\\)$", var.schedule))
    error_message = "resource_aws_kendra_data_source, schedule must be a valid cron expression format."
  }
}

variable "tags" {
  description = "(Optional) Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "configuration" {
  description = "(Optional) A block with the configuration information to connect to your Data Source repository."
  type = object({
    s3_configuration = optional(object({
      bucket_name        = string
      exclusion_patterns = optional(list(string))
      inclusion_patterns = optional(list(string))
      inclusion_prefixes = optional(list(string))
      access_control_list_configuration = optional(object({
        key_path = optional(string)
      }))
      documents_metadata_configuration = optional(object({
        s3_prefix = optional(string)
      }))
    }))
    template_configuration = optional(object({
      template = string
    }))
    web_crawler_configuration = optional(object({
      crawl_depth                             = optional(number)
      max_content_size_per_page_in_mega_bytes = optional(number)
      max_links_per_page                      = optional(number)
      max_urls_per_minute_crawl_rate          = optional(number)
      url_exclusion_patterns                  = optional(list(string))
      url_inclusion_patterns                  = optional(list(string))
      authentication_configuration = optional(object({
        basic_authentication = optional(object({
          credentials = string
          host        = string
          port        = string
        }))
      }))
      proxy_configuration = optional(object({
        credentials = optional(string)
        host        = string
        port        = string
      }))
      urls = object({
        seed_url_configuration = optional(object({
          seed_urls        = list(string)
          web_crawler_mode = optional(string)
        }))
        site_maps_configuration = optional(object({
          site_maps = list(string)
        }))
      })
    }))
  })
  default = null

  validation {
    condition = var.configuration == null || (
      var.configuration.s3_configuration == null ||
      var.configuration.template_configuration == null ||
      var.configuration.web_crawler_configuration == null
    )
    error_message = "resource_aws_kendra_data_source, configuration can only contain one of s3_configuration, template_configuration, or web_crawler_configuration."
  }

  validation {
    condition = var.configuration == null || var.configuration.s3_configuration == null || (
      var.configuration.s3_configuration.bucket_name != null &&
      length(var.configuration.s3_configuration.bucket_name) > 0
    )
    error_message = "resource_aws_kendra_data_source, configuration.s3_configuration.bucket_name is required when s3_configuration is specified."
  }

  validation {
    condition = var.configuration == null || var.configuration.template_configuration == null || (
      var.configuration.template_configuration.template != null &&
      length(var.configuration.template_configuration.template) > 0
    )
    error_message = "resource_aws_kendra_data_source, configuration.template_configuration.template is required when template_configuration is specified."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || (
      var.configuration.web_crawler_configuration.urls != null
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.urls is required when web_crawler_configuration is specified."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.crawl_depth == null || (
      var.configuration.web_crawler_configuration.crawl_depth >= 0 &&
      var.configuration.web_crawler_configuration.crawl_depth <= 10
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.crawl_depth must be between 0 and 10."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.max_content_size_per_page_in_mega_bytes == null || (
      var.configuration.web_crawler_configuration.max_content_size_per_page_in_mega_bytes >= 0.000001 &&
      var.configuration.web_crawler_configuration.max_content_size_per_page_in_mega_bytes <= 50
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.max_content_size_per_page_in_mega_bytes must be between 0.000001 and 50."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.max_links_per_page == null || (
      var.configuration.web_crawler_configuration.max_links_per_page >= 1 &&
      var.configuration.web_crawler_configuration.max_links_per_page <= 1000
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.max_links_per_page must be between 1 and 1000."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.max_urls_per_minute_crawl_rate == null || (
      var.configuration.web_crawler_configuration.max_urls_per_minute_crawl_rate >= 1 &&
      var.configuration.web_crawler_configuration.max_urls_per_minute_crawl_rate <= 300
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.max_urls_per_minute_crawl_rate must be between 1 and 300."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.url_exclusion_patterns == null || (
      length(var.configuration.web_crawler_configuration.url_exclusion_patterns) <= 100
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.url_exclusion_patterns can contain a maximum of 100 items."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.url_inclusion_patterns == null || (
      length(var.configuration.web_crawler_configuration.url_inclusion_patterns) <= 100
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.url_inclusion_patterns can contain a maximum of 100 items."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.urls.seed_url_configuration == null || var.configuration.web_crawler_configuration.urls.seed_url_configuration.seed_urls == null || (
      length(var.configuration.web_crawler_configuration.urls.seed_url_configuration.seed_urls) <= 100
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.urls.seed_url_configuration.seed_urls can contain a maximum of 100 seed URLs."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.urls.seed_url_configuration == null || var.configuration.web_crawler_configuration.urls.seed_url_configuration.web_crawler_mode == null || contains([
      "HOST_ONLY", "SUBDOMAINS", "EVERYTHING"
    ], var.configuration.web_crawler_configuration.urls.seed_url_configuration.web_crawler_mode)
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.urls.seed_url_configuration.web_crawler_mode must be HOST_ONLY, SUBDOMAINS, or EVERYTHING."
  }

  validation {
    condition = var.configuration == null || var.configuration.web_crawler_configuration == null || var.configuration.web_crawler_configuration.urls.site_maps_configuration == null || var.configuration.web_crawler_configuration.urls.site_maps_configuration.site_maps == null || (
      length(var.configuration.web_crawler_configuration.urls.site_maps_configuration.site_maps) <= 3
    )
    error_message = "resource_aws_kendra_data_source, configuration.web_crawler_configuration.urls.site_maps_configuration.site_maps can contain a maximum of 3 sitemap URLs."
  }
}

variable "custom_document_enrichment_configuration" {
  description = "(Optional) A block with the configuration information for altering document metadata and content during the document ingestion process."
  type = object({
    role_arn = optional(string)
    inline_configurations = optional(list(object({
      document_content_deletion = optional(bool)
      condition = optional(object({
        condition_document_attribute_key = string
        operator                         = string
        condition_on_value = optional(object({
          date_value        = optional(string)
          long_value        = optional(number)
          string_list_value = optional(list(string))
          string_value      = optional(string)
        }))
      }))
      target = optional(object({
        target_document_attribute_key            = optional(string)
        target_document_attribute_value_deletion = optional(bool)
        target_document_attribute_value = optional(object({
          date_value        = optional(string)
          long_value        = optional(number)
          string_list_value = optional(list(string))
          string_value      = optional(string)
        }))
      }))
    })))
    post_extraction_hook_configuration = optional(object({
      lambda_arn = string
      s3_bucket  = string
      invocation_condition = optional(object({
        condition_document_attribute_key = string
        operator                         = string
        condition_on_value = optional(object({
          date_value        = optional(string)
          long_value        = optional(number)
          string_list_value = optional(list(string))
          string_value      = optional(string)
        }))
      }))
    }))
    pre_extraction_hook_configuration = optional(object({
      lambda_arn = string
      s3_bucket  = string
      invocation_condition = optional(object({
        condition_document_attribute_key = string
        operator                         = string
        condition_on_value = optional(object({
          date_value        = optional(string)
          long_value        = optional(number)
          string_list_value = optional(list(string))
          string_value      = optional(string)
        }))
      }))
    }))
  })
  default = null

  validation {
    condition     = var.custom_document_enrichment_configuration == null || var.custom_document_enrichment_configuration.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.custom_document_enrichment_configuration.role_arn))
    error_message = "resource_aws_kendra_data_source, custom_document_enrichment_configuration.role_arn must be a valid IAM role ARN format."
  }

  validation {
    condition     = var.custom_document_enrichment_configuration == null || var.custom_document_enrichment_configuration.inline_configurations == null || length(var.custom_document_enrichment_configuration.inline_configurations) <= 100
    error_message = "resource_aws_kendra_data_source, custom_document_enrichment_configuration.inline_configurations can contain a maximum of 100 items."
  }

  validation {
    condition     = var.custom_document_enrichment_configuration == null || var.custom_document_enrichment_configuration.post_extraction_hook_configuration == null || var.custom_document_enrichment_configuration.post_extraction_hook_configuration.lambda_arn == null || can(regex("^arn:aws:lambda:[a-z0-9-]+:[0-9]{12}:function:[a-zA-Z0-9-_]+$", var.custom_document_enrichment_configuration.post_extraction_hook_configuration.lambda_arn))
    error_message = "resource_aws_kendra_data_source, custom_document_enrichment_configuration.post_extraction_hook_configuration.lambda_arn must be a valid Lambda function ARN format."
  }

  validation {
    condition     = var.custom_document_enrichment_configuration == null || var.custom_document_enrichment_configuration.pre_extraction_hook_configuration == null || var.custom_document_enrichment_configuration.pre_extraction_hook_configuration.lambda_arn == null || can(regex("^arn:aws:lambda:[a-z0-9-]+:[0-9]{12}:function:[a-zA-Z0-9-_]+$", var.custom_document_enrichment_configuration.pre_extraction_hook_configuration.lambda_arn))
    error_message = "resource_aws_kendra_data_source, custom_document_enrichment_configuration.pre_extraction_hook_configuration.lambda_arn must be a valid Lambda function ARN format."
  }



}