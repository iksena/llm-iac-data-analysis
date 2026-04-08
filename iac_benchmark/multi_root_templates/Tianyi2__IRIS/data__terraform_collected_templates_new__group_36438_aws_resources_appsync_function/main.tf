resource "aws_appsync_function" "this" {
  api_id                    = var.api_id
  data_source               = var.data_source
  name                      = var.name
  code                      = var.code
  max_batch_size            = var.max_batch_size
  request_mapping_template  = var.request_mapping_template
  response_mapping_template = var.response_mapping_template
  description               = var.description
  function_version          = var.function_version
  region                    = var.region

  dynamic "runtime" {
    for_each = var.runtime != null ? [var.runtime] : []
    content {
      name            = runtime.value.name
      runtime_version = runtime.value.runtime_version
    }
  }

  dynamic "sync_config" {
    for_each = var.sync_config != null ? [var.sync_config] : []
    content {
      conflict_detection = sync_config.value.conflict_detection
      conflict_handler   = sync_config.value.conflict_handler

      dynamic "lambda_conflict_handler_config" {
        for_each = sync_config.value.lambda_conflict_handler_config != null ? [sync_config.value.lambda_conflict_handler_config] : []
        content {
          lambda_conflict_handler_arn = lambda_conflict_handler_config.value.lambda_conflict_handler_arn
        }
      }
    }
  }
}