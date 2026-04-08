resource "aws_kendra_data_source" "this" {
  index_id      = var.index_id
  name          = var.name
  role_arn      = var.role_arn
  type          = var.type
  region        = var.region
  description   = var.description
  language_code = var.language_code
  schedule      = var.schedule
  tags          = var.tags

  dynamic "configuration" {
    for_each = var.configuration != null ? [var.configuration] : []
    content {
      dynamic "s3_configuration" {
        for_each = configuration.value.s3_configuration != null ? [configuration.value.s3_configuration] : []
        content {
          bucket_name        = s3_configuration.value.bucket_name
          exclusion_patterns = s3_configuration.value.exclusion_patterns
          inclusion_patterns = s3_configuration.value.inclusion_patterns
          inclusion_prefixes = s3_configuration.value.inclusion_prefixes

          dynamic "access_control_list_configuration" {
            for_each = s3_configuration.value.access_control_list_configuration != null ? [s3_configuration.value.access_control_list_configuration] : []
            content {
              key_path = access_control_list_configuration.value.key_path
            }
          }

          dynamic "documents_metadata_configuration" {
            for_each = s3_configuration.value.documents_metadata_configuration != null ? [s3_configuration.value.documents_metadata_configuration] : []
            content {
              s3_prefix = documents_metadata_configuration.value.s3_prefix
            }
          }
        }
      }

      dynamic "template_configuration" {
        for_each = configuration.value.template_configuration != null ? [configuration.value.template_configuration] : []
        content {
          template = template_configuration.value.template
        }
      }

      dynamic "web_crawler_configuration" {
        for_each = configuration.value.web_crawler_configuration != null ? [configuration.value.web_crawler_configuration] : []
        content {
          crawl_depth                             = web_crawler_configuration.value.crawl_depth
          max_content_size_per_page_in_mega_bytes = web_crawler_configuration.value.max_content_size_per_page_in_mega_bytes
          max_links_per_page                      = web_crawler_configuration.value.max_links_per_page
          max_urls_per_minute_crawl_rate          = web_crawler_configuration.value.max_urls_per_minute_crawl_rate
          url_exclusion_patterns                  = web_crawler_configuration.value.url_exclusion_patterns
          url_inclusion_patterns                  = web_crawler_configuration.value.url_inclusion_patterns

          dynamic "authentication_configuration" {
            for_each = web_crawler_configuration.value.authentication_configuration != null ? [web_crawler_configuration.value.authentication_configuration] : []
            content {
              dynamic "basic_authentication" {
                for_each = authentication_configuration.value.basic_authentication != null ? [authentication_configuration.value.basic_authentication] : []
                content {
                  credentials = basic_authentication.value.credentials
                  host        = basic_authentication.value.host
                  port        = basic_authentication.value.port
                }
              }
            }
          }

          dynamic "proxy_configuration" {
            for_each = web_crawler_configuration.value.proxy_configuration != null ? [web_crawler_configuration.value.proxy_configuration] : []
            content {
              credentials = proxy_configuration.value.credentials
              host        = proxy_configuration.value.host
              port        = proxy_configuration.value.port
            }
          }

          dynamic "urls" {
            for_each = web_crawler_configuration.value.urls != null ? [web_crawler_configuration.value.urls] : []
            content {
              dynamic "seed_url_configuration" {
                for_each = urls.value.seed_url_configuration != null ? [urls.value.seed_url_configuration] : []
                content {
                  seed_urls        = seed_url_configuration.value.seed_urls
                  web_crawler_mode = seed_url_configuration.value.web_crawler_mode
                }
              }

              dynamic "site_maps_configuration" {
                for_each = urls.value.site_maps_configuration != null ? [urls.value.site_maps_configuration] : []
                content {
                  site_maps = site_maps_configuration.value.site_maps
                }
              }
            }
          }
        }
      }
    }
  }

  dynamic "custom_document_enrichment_configuration" {
    for_each = var.custom_document_enrichment_configuration != null ? [var.custom_document_enrichment_configuration] : []
    content {
      role_arn = custom_document_enrichment_configuration.value.role_arn

      dynamic "inline_configurations" {
        for_each = custom_document_enrichment_configuration.value.inline_configurations != null ? custom_document_enrichment_configuration.value.inline_configurations : []
        content {
          document_content_deletion = inline_configurations.value.document_content_deletion

          dynamic "condition" {
            for_each = inline_configurations.value.condition != null ? [inline_configurations.value.condition] : []
            content {
              condition_document_attribute_key = condition.value.condition_document_attribute_key
              operator                         = condition.value.operator

              dynamic "condition_on_value" {
                for_each = condition.value.condition_on_value != null ? [condition.value.condition_on_value] : []
                content {
                  date_value        = condition_on_value.value.date_value
                  long_value        = condition_on_value.value.long_value
                  string_list_value = condition_on_value.value.string_list_value
                  string_value      = condition_on_value.value.string_value
                }
              }
            }
          }

          dynamic "target" {
            for_each = inline_configurations.value.target != null ? [inline_configurations.value.target] : []
            content {
              target_document_attribute_key            = target.value.target_document_attribute_key
              target_document_attribute_value_deletion = target.value.target_document_attribute_value_deletion

              dynamic "target_document_attribute_value" {
                for_each = target.value.target_document_attribute_value != null ? [target.value.target_document_attribute_value] : []
                content {
                  date_value        = target_document_attribute_value.value.date_value
                  long_value        = target_document_attribute_value.value.long_value
                  string_list_value = target_document_attribute_value.value.string_list_value
                  string_value      = target_document_attribute_value.value.string_value
                }
              }
            }
          }
        }
      }

      dynamic "post_extraction_hook_configuration" {
        for_each = custom_document_enrichment_configuration.value.post_extraction_hook_configuration != null ? [custom_document_enrichment_configuration.value.post_extraction_hook_configuration] : []
        content {
          lambda_arn = post_extraction_hook_configuration.value.lambda_arn
          s3_bucket  = post_extraction_hook_configuration.value.s3_bucket

          dynamic "invocation_condition" {
            for_each = post_extraction_hook_configuration.value.invocation_condition != null ? [post_extraction_hook_configuration.value.invocation_condition] : []
            content {
              condition_document_attribute_key = invocation_condition.value.condition_document_attribute_key
              operator                         = invocation_condition.value.operator

              dynamic "condition_on_value" {
                for_each = invocation_condition.value.condition_on_value != null ? [invocation_condition.value.condition_on_value] : []
                content {
                  date_value        = condition_on_value.value.date_value
                  long_value        = condition_on_value.value.long_value
                  string_list_value = condition_on_value.value.string_list_value
                  string_value      = condition_on_value.value.string_value
                }
              }
            }
          }
        }
      }

      dynamic "pre_extraction_hook_configuration" {
        for_each = custom_document_enrichment_configuration.value.pre_extraction_hook_configuration != null ? [custom_document_enrichment_configuration.value.pre_extraction_hook_configuration] : []
        content {
          lambda_arn = pre_extraction_hook_configuration.value.lambda_arn
          s3_bucket  = pre_extraction_hook_configuration.value.s3_bucket

          dynamic "invocation_condition" {
            for_each = pre_extraction_hook_configuration.value.invocation_condition != null ? [pre_extraction_hook_configuration.value.invocation_condition] : []
            content {
              condition_document_attribute_key = invocation_condition.value.condition_document_attribute_key
              operator                         = invocation_condition.value.operator

              dynamic "condition_on_value" {
                for_each = invocation_condition.value.condition_on_value != null ? [invocation_condition.value.condition_on_value] : []
                content {
                  date_value        = condition_on_value.value.date_value
                  long_value        = condition_on_value.value.long_value
                  string_list_value = condition_on_value.value.string_list_value
                  string_value      = condition_on_value.value.string_value
                }
              }
            }
          }
        }
      }
    }
  }
}