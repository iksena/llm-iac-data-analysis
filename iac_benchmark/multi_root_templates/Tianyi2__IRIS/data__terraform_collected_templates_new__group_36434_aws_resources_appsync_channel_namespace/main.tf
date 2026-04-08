resource "aws_appsync_channel_namespace" "this" {
  api_id = var.api_id
  name   = var.name

  code_handlers = var.code_handlers
  region        = var.region
  tags          = var.tags

  dynamic "publish_auth_mode" {
    for_each = var.publish_auth_mode != null ? [var.publish_auth_mode] : []
    content {
      auth_type = publish_auth_mode.value.auth_type
    }
  }

  dynamic "subscribe_auth_mode" {
    for_each = var.subscribe_auth_mode != null ? [var.subscribe_auth_mode] : []
    content {
      auth_type = subscribe_auth_mode.value.auth_type
    }
  }

  dynamic "handler_configs" {
    for_each = var.handler_configs != null ? [var.handler_configs] : []
    content {
      dynamic "on_publish" {
        for_each = handler_configs.value.on_publish != null ? [handler_configs.value.on_publish] : []
        content {
          behavior = on_publish.value.behavior

          integration {
            data_source_name = on_publish.value.integration.data_source_name

            dynamic "lambda_config" {
              for_each = on_publish.value.integration.lambda_config != null ? [on_publish.value.integration.lambda_config] : []
              content {
                invoke_type = lambda_config.value.invoke_type
              }
            }
          }
        }
      }

      dynamic "on_subscribe" {
        for_each = handler_configs.value.on_subscribe != null ? [handler_configs.value.on_subscribe] : []
        content {
          behavior = on_subscribe.value.behavior

          integration {
            data_source_name = on_subscribe.value.integration.data_source_name

            dynamic "lambda_config" {
              for_each = on_subscribe.value.integration.lambda_config != null ? [on_subscribe.value.integration.lambda_config] : []
              content {
                invoke_type = lambda_config.value.invoke_type
              }
            }
          }
        }
      }
    }
  }
}