resource "aws_bedrockagent_data_source" "this" {
  knowledge_base_id    = var.knowledge_base_id
  name                 = var.name
  region               = var.region
  data_deletion_policy = var.data_deletion_policy
  description          = var.description

  data_source_configuration {
    type = var.data_source_configuration.type

    dynamic "confluence_configuration" {
      for_each = var.data_source_configuration.confluence_configuration != null ? [var.data_source_configuration.confluence_configuration] : []
      content {
        dynamic "source_configuration" {
          for_each = [confluence_configuration.value.source_configuration]
          content {
            auth_type              = source_configuration.value.auth_type
            credentials_secret_arn = source_configuration.value.credentials_secret_arn
            host_type              = source_configuration.value.host_type
            host_url               = source_configuration.value.host_url
          }
        }

        dynamic "crawler_configuration" {
          for_each = confluence_configuration.value.crawler_configuration != null ? [confluence_configuration.value.crawler_configuration] : []
          content {
            dynamic "filter_configuration" {
              for_each = crawler_configuration.value.filter_configuration != null ? [crawler_configuration.value.filter_configuration] : []
              content {
                type = filter_configuration.value.type

                dynamic "pattern_object_filter" {
                  for_each = filter_configuration.value.pattern_object_filter != null ? [filter_configuration.value.pattern_object_filter] : []
                  content {
                    dynamic "filters" {
                      for_each = pattern_object_filter.value.filters
                      content {
                        object_type       = filters.value.object_type
                        exclusion_filters = filters.value.exclusion_filters
                        inclusion_filters = filters.value.inclusion_filters
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    dynamic "s3_configuration" {
      for_each = var.data_source_configuration.s3_configuration != null ? [var.data_source_configuration.s3_configuration] : []
      content {
        bucket_arn              = s3_configuration.value.bucket_arn
        bucket_owner_account_id = s3_configuration.value.bucket_owner_account_id
        inclusion_prefixes      = s3_configuration.value.inclusion_prefixes
      }
    }

    dynamic "salesforce_configuration" {
      for_each = var.data_source_configuration.salesforce_configuration != null ? [var.data_source_configuration.salesforce_configuration] : []
      content {
        dynamic "source_configuration" {
          for_each = [salesforce_configuration.value.source_configuration]
          content {
            auth_type              = source_configuration.value.auth_type
            credentials_secret_arn = source_configuration.value.credentials_secret_arn
            host_url               = source_configuration.value.host_url
          }

        }

        dynamic "crawler_configuration" {
          for_each = salesforce_configuration.value.crawler_configuration != null ? [salesforce_configuration.value.crawler_configuration] : []
          content {
            dynamic "filter_configuration" {
              for_each = crawler_configuration.value.filter_configuration != null ? [crawler_configuration.value.filter_configuration] : []
              content {
                type = filter_configuration.value.type

                dynamic "pattern_object_filter" {
                  for_each = filter_configuration.value.pattern_object_filter != null ? [filter_configuration.value.pattern_object_filter] : []
                  content {
                    dynamic "filters" {
                      for_each = pattern_object_filter.value.filters
                      content {
                        object_type       = filters.value.object_type
                        exclusion_filters = filters.value.exclusion_filters
                        inclusion_filters = filters.value.inclusion_filters
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    dynamic "share_point_configuration" {
      for_each = var.data_source_configuration.share_point_configuration != null ? [var.data_source_configuration.share_point_configuration] : []
      content {
        dynamic "source_configuration" {
          for_each = [share_point_configuration.value.source_configuration]
          content {
            auth_type              = source_configuration.value.auth_type
            credentials_secret_arn = source_configuration.value.credentials_secret_arn
            domain                 = source_configuration.value.domain
            host_type              = source_configuration.value.host_type
            site_urls              = source_configuration.value.site_urls
            tenant_id              = source_configuration.value.tenant_id
          }
        }

        dynamic "crawler_configuration" {
          for_each = share_point_configuration.value.crawler_configuration != null ? [share_point_configuration.value.crawler_configuration] : []
          content {
            dynamic "filter_configuration" {
              for_each = crawler_configuration.value.filter_configuration != null ? [crawler_configuration.value.filter_configuration] : []
              content {
                type = filter_configuration.value.type

                dynamic "pattern_object_filter" {
                  for_each = filter_configuration.value.pattern_object_filter != null ? [filter_configuration.value.pattern_object_filter] : []
                  content {
                    dynamic "filters" {
                      for_each = pattern_object_filter.value.filters
                      content {
                        object_type       = filters.value.object_type
                        exclusion_filters = filters.value.exclusion_filters
                        inclusion_filters = filters.value.inclusion_filters
                      }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }

    dynamic "web_configuration" {
      for_each = var.data_source_configuration.web_configuration != null ? [var.data_source_configuration.web_configuration] : []
      content {
        dynamic "source_configuration" {
          for_each = [web_configuration.value.source_configuration]
          content {
            dynamic "url_configuration" {
              for_each = [source_configuration.value.url_configuration]
              content {
                dynamic "seed_urls" {
                  for_each = url_configuration.value.seed_urls != null ? url_configuration.value.seed_urls : []
                  content {
                    url = seed_urls.value.url
                  }
                }
              }
            }
          }
        }

        dynamic "crawler_configuration" {
          for_each = web_configuration.value.crawler_configuration != null ? [web_configuration.value.crawler_configuration] : []
          content {
            exclusion_filters = crawler_configuration.value.exclusion_filters
            inclusion_filters = crawler_configuration.value.inclusion_filters
            scope             = crawler_configuration.value.scope
            user_agent        = crawler_configuration.value.user_agent

            dynamic "crawler_limits" {
              for_each = crawler_configuration.value.crawler_limits != null ? [crawler_configuration.value.crawler_limits] : []
              content {
                max_pages  = crawler_limits.value.max_pages
                rate_limit = crawler_limits.value.rate_limit
              }
            }
          }
        }
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration != null ? [var.server_side_encryption_configuration] : []
    content {
      kms_key_arn = server_side_encryption_configuration.value.kms_key_arn
    }
  }

  dynamic "vector_ingestion_configuration" {
    for_each = var.vector_ingestion_configuration != null ? [var.vector_ingestion_configuration] : []
    content {
      dynamic "chunking_configuration" {
        for_each = vector_ingestion_configuration.value.chunking_configuration != null ? [vector_ingestion_configuration.value.chunking_configuration] : []
        content {
          chunking_strategy = chunking_configuration.value.chunking_strategy

          dynamic "fixed_size_chunking_configuration" {
            for_each = chunking_configuration.value.fixed_size_chunking_configuration != null ? [chunking_configuration.value.fixed_size_chunking_configuration] : []
            content {
              max_tokens         = fixed_size_chunking_configuration.value.max_tokens
              overlap_percentage = fixed_size_chunking_configuration.value.overlap_percentage
            }
          }

          dynamic "hierarchical_chunking_configuration" {
            for_each = chunking_configuration.value.hierarchical_chunking_configuration != null ? [chunking_configuration.value.hierarchical_chunking_configuration] : []
            content {
              overlap_tokens = hierarchical_chunking_configuration.value.overlap_tokens

              dynamic "level_configuration" {
                for_each = hierarchical_chunking_configuration.value.level_configuration
                content {
                  max_tokens = level_configuration.value.max_tokens
                }
              }
            }
          }

          dynamic "semantic_chunking_configuration" {
            for_each = chunking_configuration.value.semantic_chunking_configuration != null ? [chunking_configuration.value.semantic_chunking_configuration] : []
            content {
              breakpoint_percentile_threshold = semantic_chunking_configuration.value.breakpoint_percentile_threshold
              buffer_size                     = semantic_chunking_configuration.value.buffer_size
              max_token                       = semantic_chunking_configuration.value.max_token
            }
          }
        }
      }

      dynamic "custom_transformation_configuration" {
        for_each = vector_ingestion_configuration.value.custom_transformation_configuration != null ? [vector_ingestion_configuration.value.custom_transformation_configuration] : []
        content {
          dynamic "intermediate_storage" {
            for_each = [custom_transformation_configuration.value.intermediate_storage]
            content {
              dynamic "s3_location" {
                for_each = [intermediate_storage.value.s3_location]
                content {
                  uri = s3_location.value.uri
                }
              }
            }
          }

          dynamic "transformation" {
            for_each = [custom_transformation_configuration.value.transformation]
            content {
              step_to_apply = transformation.value.step_to_apply

              dynamic "transformation_function" {
                for_each = [transformation.value.transformation_function]
                content {
                  dynamic "transformation_lambda_configuration" {
                    for_each = [transformation_function.value.transformation_lambda_configuration]
                    content {
                      lambda_arn = transformation_lambda_configuration.value.lambda_arn
                    }
                  }
                }
              }
            }
          }
        }
      }

      dynamic "parsing_configuration" {
        for_each = vector_ingestion_configuration.value.parsing_configuration != null ? [vector_ingestion_configuration.value.parsing_configuration] : []
        content {
          parsing_strategy = parsing_configuration.value.parsing_strategy

          dynamic "bedrock_foundation_model_configuration" {
            for_each = parsing_configuration.value.bedrock_foundation_model_configuration != null ? [parsing_configuration.value.bedrock_foundation_model_configuration] : []
            content {
              model_arn = bedrock_foundation_model_configuration.value.model_arn

              dynamic "parsing_prompt" {
                for_each = bedrock_foundation_model_configuration.value.parsing_prompt != null ? [bedrock_foundation_model_configuration.value.parsing_prompt] : []
                content {
                  parsing_prompt_string = parsing_prompt.value.parsing_prompt_string
                }
              }
            }
          }
        }
      }
    }
  }
}