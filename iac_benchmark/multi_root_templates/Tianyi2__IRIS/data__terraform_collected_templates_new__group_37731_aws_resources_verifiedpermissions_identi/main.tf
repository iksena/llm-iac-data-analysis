resource "aws_verifiedpermissions_identity_source" "this" {
  region                = var.region
  policy_store_id       = var.policy_store_id
  principal_entity_type = var.principal_entity_type

  dynamic "configuration" {
    for_each = var.configuration != null ? [var.configuration] : []
    content {
      dynamic "cognito_user_pool_configuration" {
        for_each = configuration.value.cognito_user_pool_configuration != null ? [configuration.value.cognito_user_pool_configuration] : []
        content {
          user_pool_arn = cognito_user_pool_configuration.value.user_pool_arn
          client_ids    = cognito_user_pool_configuration.value.client_ids

          dynamic "group_configuration" {
            for_each = cognito_user_pool_configuration.value.group_configuration != null ? [cognito_user_pool_configuration.value.group_configuration] : []
            content {
              group_entity_type = group_configuration.value.group_entity_type
            }
          }
        }
      }

      dynamic "open_id_connect_configuration" {
        for_each = configuration.value.open_id_connect_configuration != null ? [configuration.value.open_id_connect_configuration] : []
        content {
          issuer           = open_id_connect_configuration.value.issuer
          entity_id_prefix = open_id_connect_configuration.value.entity_id_prefix

          dynamic "token_selection" {
            for_each = open_id_connect_configuration.value.token_selection != null ? [open_id_connect_configuration.value.token_selection] : []
            content {
              dynamic "access_token_only" {
                for_each = token_selection.value.access_token_only != null ? [token_selection.value.access_token_only] : []
                content {
                  audiences          = access_token_only.value.audiences
                  principal_id_claim = access_token_only.value.principal_id_claim
                }
              }

              dynamic "identity_token_only" {
                for_each = token_selection.value.identity_token_only != null ? [token_selection.value.identity_token_only] : []
                content {
                  client_ids = identity_token_only.value.client_ids
                }
              }
            }
          }

          dynamic "group_configuration" {
            for_each = open_id_connect_configuration.value.group_configuration != null ? [open_id_connect_configuration.value.group_configuration] : []
            content {
              group_claim       = group_configuration.value.group_claim
              group_entity_type = group_configuration.value.group_entity_type
            }
          }
        }
      }
    }
  }
}