variable "name" {
  description = "Name of the knowledge base."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_bedrockagent_knowledge_base, name must not be empty."
  }
}

variable "role_arn" {
  description = "ARN of the IAM role with permissions to invoke API operations on the knowledge base."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::", var.role_arn))
    error_message = "resource_aws_bedrockagent_knowledge_base, role_arn must be a valid IAM role ARN."
  }
}

variable "knowledge_base_configuration" {
  description = "Details about the embeddings configuration of the knowledge base."
  type = object({
    type = string
    vector_knowledge_base_configuration = optional(object({
      embedding_model_arn = string
      embedding_model_configuration = optional(object({
        bedrock_embedding_model_configuration = optional(object({
          dimensions          = optional(number)
          embedding_data_type = optional(string)
        }))
      }))
      supplemental_data_storage_configuration = optional(object({
        storage_location = object({
          type = string
          s3_location = optional(object({
            uri = string
          }))
        })
      }))
    }))
  })

  validation {
    condition     = contains(["VECTOR"], var.knowledge_base_configuration.type)
    error_message = "resource_aws_bedrockagent_knowledge_base, knowledge_base_configuration.type must be 'VECTOR'."
  }

  validation {
    condition     = var.knowledge_base_configuration.vector_knowledge_base_configuration == null ? true : can(regex("^arn:aws:bedrock:", var.knowledge_base_configuration.vector_knowledge_base_configuration.embedding_model_arn))
    error_message = "resource_aws_bedrockagent_knowledge_base, knowledge_base_configuration.vector_knowledge_base_configuration.embedding_model_arn must be a valid Bedrock model ARN."
  }

  validation {
    condition = var.knowledge_base_configuration.vector_knowledge_base_configuration == null ? true : (
      var.knowledge_base_configuration.vector_knowledge_base_configuration.embedding_model_configuration == null ? true : (
        var.knowledge_base_configuration.vector_knowledge_base_configuration.embedding_model_configuration.bedrock_embedding_model_configuration == null ? true : (
          var.knowledge_base_configuration.vector_knowledge_base_configuration.embedding_model_configuration.bedrock_embedding_model_configuration.embedding_data_type == null ? true :
          contains(["FLOAT32", "BINARY"], var.knowledge_base_configuration.vector_knowledge_base_configuration.embedding_model_configuration.bedrock_embedding_model_configuration.embedding_data_type)
        )
      )
    )
    error_message = "resource_aws_bedrockagent_knowledge_base, knowledge_base_configuration.vector_knowledge_base_configuration.embedding_model_configuration.bedrock_embedding_model_configuration.embedding_data_type must be 'FLOAT32' or 'BINARY'."
  }

  validation {
    condition = var.knowledge_base_configuration.vector_knowledge_base_configuration == null ? true : (
      var.knowledge_base_configuration.vector_knowledge_base_configuration.supplemental_data_storage_configuration == null ? true :
      var.knowledge_base_configuration.vector_knowledge_base_configuration.supplemental_data_storage_configuration.storage_location.type == "S3"
    )
    error_message = "resource_aws_bedrockagent_knowledge_base, knowledge_base_configuration.vector_knowledge_base_configuration.supplemental_data_storage_configuration.storage_location.type must be 'S3'."
  }
}

variable "storage_configuration" {
  description = "Details about the storage configuration of the knowledge base."
  type = object({
    type = string
    opensearch_serverless_configuration = optional(object({
      collection_arn    = string
      vector_index_name = string
      field_mapping = object({
        metadata_field = string
        text_field     = string
        vector_field   = string
      })
    }))
    pinecone_configuration = optional(object({
      connection_string      = string
      credentials_secret_arn = string
      field_mapping = object({
        metadata_field = string
        text_field     = string
      })
      namespace = optional(string)
    }))
    rds_configuration = optional(object({
      credentials_secret_arn = string
      database_name          = string
      resource_arn           = string
      table_name             = string
      field_mapping = object({
        metadata_field    = string
        primary_key_field = string
        text_field        = string
        vector_field      = string
      })
    }))
    redis_enterprise_cloud_configuration = optional(object({
      credentials_secret_arn = string
      endpoint               = string
      vector_index_name      = string
      field_mapping = object({
        metadata_field = string
        text_field     = string
        vector_field   = string
      })
    }))
  })

  validation {
    condition     = contains(["OPENSEARCH_SERVERLESS", "PINECONE", "REDIS_ENTERPRISE_CLOUD", "RDS"], var.storage_configuration.type)
    error_message = "resource_aws_bedrockagent_knowledge_base, storage_configuration.type must be one of 'OPENSEARCH_SERVERLESS', 'PINECONE', 'REDIS_ENTERPRISE_CLOUD', or 'RDS'."
  }

  validation {
    condition     = var.storage_configuration.opensearch_serverless_configuration == null ? true : can(regex("^arn:aws:aoss:", var.storage_configuration.opensearch_serverless_configuration.collection_arn))
    error_message = "resource_aws_bedrockagent_knowledge_base, storage_configuration.opensearch_serverless_configuration.collection_arn must be a valid OpenSearch Serverless collection ARN."
  }

  validation {
    condition     = var.storage_configuration.pinecone_configuration == null ? true : can(regex("^arn:aws:secretsmanager:", var.storage_configuration.pinecone_configuration.credentials_secret_arn))
    error_message = "resource_aws_bedrockagent_knowledge_base, storage_configuration.pinecone_configuration.credentials_secret_arn must be a valid Secrets Manager ARN."
  }

  validation {
    condition     = var.storage_configuration.rds_configuration == null ? true : can(regex("^arn:aws:secretsmanager:", var.storage_configuration.rds_configuration.credentials_secret_arn))
    error_message = "resource_aws_bedrockagent_knowledge_base, storage_configuration.rds_configuration.credentials_secret_arn must be a valid Secrets Manager ARN."
  }

  validation {
    condition     = var.storage_configuration.rds_configuration == null ? true : can(regex("^arn:aws:rds:", var.storage_configuration.rds_configuration.resource_arn))
    error_message = "resource_aws_bedrockagent_knowledge_base, storage_configuration.rds_configuration.resource_arn must be a valid RDS ARN."
  }

  validation {
    condition     = var.storage_configuration.redis_enterprise_cloud_configuration == null ? true : can(regex("^arn:aws:secretsmanager:", var.storage_configuration.redis_enterprise_cloud_configuration.credentials_secret_arn))
    error_message = "resource_aws_bedrockagent_knowledge_base, storage_configuration.redis_enterprise_cloud_configuration.credentials_secret_arn must be a valid Secrets Manager ARN."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the knowledge base."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags assigned to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = null
}