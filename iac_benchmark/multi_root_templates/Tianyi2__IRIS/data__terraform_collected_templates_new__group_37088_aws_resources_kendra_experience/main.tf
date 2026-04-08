resource "aws_kendra_experience" "this" {
  index_id    = var.index_id
  name        = var.name
  role_arn    = var.role_arn
  description = var.description
  region      = var.region

  dynamic "configuration" {
    for_each = var.configuration != null ? [var.configuration] : []
    content {
      dynamic "content_source_configuration" {
        for_each = configuration.value.content_source_configuration != null ? [configuration.value.content_source_configuration] : []
        content {
          data_source_ids    = content_source_configuration.value.data_source_ids
          direct_put_content = content_source_configuration.value.direct_put_content
          faq_ids            = content_source_configuration.value.faq_ids
        }
      }

      dynamic "user_identity_configuration" {
        for_each = configuration.value.user_identity_configuration != null ? [configuration.value.user_identity_configuration] : []
        content {
          identity_attribute_name = user_identity_configuration.value.identity_attribute_name
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}