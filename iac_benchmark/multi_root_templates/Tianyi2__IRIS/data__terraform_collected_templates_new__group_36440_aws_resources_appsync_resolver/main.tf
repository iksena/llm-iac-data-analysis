resource "aws_appsync_resolver" "this" {
  region            = var.region
  api_id            = var.api_id
  code              = var.code
  type              = var.type
  field             = var.field
  request_template  = var.request_template
  response_template = var.response_template
  data_source       = var.data_source
  max_batch_size    = var.max_batch_size
  kind              = var.kind

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

  dynamic "pipeline_config" {
    for_each = var.pipeline_config != null ? [var.pipeline_config] : []
    content {
      functions = pipeline_config.value.functions
    }
  }

  dynamic "caching_config" {
    for_each = var.caching_config != null ? [var.caching_config] : []
    content {
      caching_keys = caching_config.value.caching_keys
      ttl          = caching_config.value.ttl
    }
  }

  dynamic "runtime" {
    for_each = var.runtime != null ? [var.runtime] : []
    content {
      name            = runtime.value.name
      runtime_version = runtime.value.runtime_version
    }
  }
}