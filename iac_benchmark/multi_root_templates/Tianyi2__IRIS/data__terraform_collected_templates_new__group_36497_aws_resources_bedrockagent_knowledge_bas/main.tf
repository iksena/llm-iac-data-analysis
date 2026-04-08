resource "aws_bedrockagent_knowledge_base" "this" {
  name        = var.name
  role_arn    = var.role_arn
  region      = var.region
  description = var.description
  tags        = var.tags

  knowledge_base_configuration {
    type = var.knowledge_base_configuration.type

    dynamic "vector_knowledge_base_configuration" {
      for_each = var.knowledge_base_configuration.vector_knowledge_base_configuration != null ? [var.knowledge_base_configuration.vector_knowledge_base_configuration] : []

      content {
        embedding_model_arn = vector_knowledge_base_configuration.value.embedding_model_arn

        dynamic "embedding_model_configuration" {
          for_each = vector_knowledge_base_configuration.value.embedding_model_configuration != null ? [vector_knowledge_base_configuration.value.embedding_model_configuration] : []

          content {
            dynamic "bedrock_embedding_model_configuration" {
              for_each = embedding_model_configuration.value.bedrock_embedding_model_configuration != null ? [embedding_model_configuration.value.bedrock_embedding_model_configuration] : []

              content {
                dimensions          = bedrock_embedding_model_configuration.value.dimensions
                embedding_data_type = bedrock_embedding_model_configuration.value.embedding_data_type
              }
            }
          }
        }

        dynamic "supplemental_data_storage_configuration" {
          for_each = vector_knowledge_base_configuration.value.supplemental_data_storage_configuration != null ? [vector_knowledge_base_configuration.value.supplemental_data_storage_configuration] : []

          content {
            storage_location {
              type = supplemental_data_storage_configuration.value.storage_location.type

              dynamic "s3_location" {
                for_each = supplemental_data_storage_configuration.value.storage_location.s3_location != null ? [supplemental_data_storage_configuration.value.storage_location.s3_location] : []

                content {
                  uri = s3_location.value.uri
                }
              }
            }
          }
        }
      }
    }
  }

  storage_configuration {
    type = var.storage_configuration.type

    dynamic "opensearch_serverless_configuration" {
      for_each = var.storage_configuration.opensearch_serverless_configuration != null ? [var.storage_configuration.opensearch_serverless_configuration] : []

      content {
        collection_arn    = opensearch_serverless_configuration.value.collection_arn
        vector_index_name = opensearch_serverless_configuration.value.vector_index_name

        field_mapping {
          metadata_field = opensearch_serverless_configuration.value.field_mapping.metadata_field
          text_field     = opensearch_serverless_configuration.value.field_mapping.text_field
          vector_field   = opensearch_serverless_configuration.value.field_mapping.vector_field
        }
      }
    }

    dynamic "pinecone_configuration" {
      for_each = var.storage_configuration.pinecone_configuration != null ? [var.storage_configuration.pinecone_configuration] : []

      content {
        connection_string      = pinecone_configuration.value.connection_string
        credentials_secret_arn = pinecone_configuration.value.credentials_secret_arn
        namespace              = pinecone_configuration.value.namespace

        field_mapping {
          metadata_field = pinecone_configuration.value.field_mapping.metadata_field
          text_field     = pinecone_configuration.value.field_mapping.text_field
        }
      }
    }

    dynamic "rds_configuration" {
      for_each = var.storage_configuration.rds_configuration != null ? [var.storage_configuration.rds_configuration] : []

      content {
        credentials_secret_arn = rds_configuration.value.credentials_secret_arn
        database_name          = rds_configuration.value.database_name
        resource_arn           = rds_configuration.value.resource_arn
        table_name             = rds_configuration.value.table_name

        field_mapping {
          metadata_field    = rds_configuration.value.field_mapping.metadata_field
          primary_key_field = rds_configuration.value.field_mapping.primary_key_field
          text_field        = rds_configuration.value.field_mapping.text_field
          vector_field      = rds_configuration.value.field_mapping.vector_field
        }
      }
    }

    dynamic "redis_enterprise_cloud_configuration" {
      for_each = var.storage_configuration.redis_enterprise_cloud_configuration != null ? [var.storage_configuration.redis_enterprise_cloud_configuration] : []

      content {
        credentials_secret_arn = redis_enterprise_cloud_configuration.value.credentials_secret_arn
        endpoint               = redis_enterprise_cloud_configuration.value.endpoint
        vector_index_name      = redis_enterprise_cloud_configuration.value.vector_index_name

        field_mapping {
          metadata_field = redis_enterprise_cloud_configuration.value.field_mapping.metadata_field
          text_field     = redis_enterprise_cloud_configuration.value.field_mapping.text_field
          vector_field   = redis_enterprise_cloud_configuration.value.field_mapping.vector_field
        }
      }
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}