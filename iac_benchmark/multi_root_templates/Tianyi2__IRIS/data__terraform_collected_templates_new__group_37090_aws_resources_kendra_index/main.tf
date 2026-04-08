resource "aws_kendra_index" "this" {
  name                = var.name
  description         = var.description
  edition             = var.edition
  role_arn            = var.role_arn
  region              = var.region
  user_context_policy = var.user_context_policy

  dynamic "capacity_units" {
    for_each = var.capacity_units != null ? [var.capacity_units] : []
    content {
      query_capacity_units   = capacity_units.value.query_capacity_units
      storage_capacity_units = capacity_units.value.storage_capacity_units
    }
  }

  dynamic "document_metadata_configuration_updates" {
    for_each = var.document_metadata_configuration_updates
    content {
      name = document_metadata_configuration_updates.value.name
      type = document_metadata_configuration_updates.value.type

      search {
        displayable = document_metadata_configuration_updates.value.search.displayable
        facetable   = document_metadata_configuration_updates.value.search.facetable
        searchable  = document_metadata_configuration_updates.value.search.searchable
        sortable    = document_metadata_configuration_updates.value.search.sortable
      }

      relevance {
        importance            = document_metadata_configuration_updates.value.relevance.importance
        duration              = document_metadata_configuration_updates.value.relevance.duration
        freshness             = document_metadata_configuration_updates.value.relevance.freshness
        rank_order            = document_metadata_configuration_updates.value.relevance.rank_order
        values_importance_map = document_metadata_configuration_updates.value.relevance.values_importance_map
      }
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_configuration != null ? [var.server_side_encryption_configuration] : []
    content {
      kms_key_id = server_side_encryption_configuration.value.kms_key_id
    }
  }

  dynamic "user_group_resolution_configuration" {
    for_each = var.user_group_resolution_configuration != null ? [var.user_group_resolution_configuration] : []
    content {
      user_group_resolution_mode = user_group_resolution_configuration.value.user_group_resolution_mode
    }
  }

  dynamic "user_token_configurations" {
    for_each = var.user_token_configurations != null ? [var.user_token_configurations] : []
    content {
      dynamic "json_token_type_configuration" {
        for_each = user_token_configurations.value.json_token_type_configuration != null ? [user_token_configurations.value.json_token_type_configuration] : []
        content {
          group_attribute_field     = json_token_type_configuration.value.group_attribute_field
          user_name_attribute_field = json_token_type_configuration.value.user_name_attribute_field
        }
      }

      dynamic "jwt_token_type_configuration" {
        for_each = user_token_configurations.value.jwt_token_type_configuration != null ? [user_token_configurations.value.jwt_token_type_configuration] : []
        content {
          key_location              = jwt_token_type_configuration.value.key_location
          claim_regex               = jwt_token_type_configuration.value.claim_regex
          group_attribute_field     = jwt_token_type_configuration.value.group_attribute_field
          issuer                    = jwt_token_type_configuration.value.issuer
          secrets_manager_arn       = jwt_token_type_configuration.value.secrets_manager_arn
          url                       = jwt_token_type_configuration.value.url
          user_name_attribute_field = jwt_token_type_configuration.value.user_name_attribute_field
        }
      }
    }
  }

  tags = var.tags
}