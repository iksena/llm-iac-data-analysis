resource "aws_ssm_document" "this" {
  region          = var.region
  name            = var.name
  content         = var.content
  document_format = var.document_format
  document_type   = var.document_type
  target_type     = var.target_type
  tags            = var.tags
  version_name    = var.version_name

  dynamic "attachments_source" {
    for_each = var.attachments_source != null ? var.attachments_source : []
    content {
      key    = attachments_source.value.key
      values = attachments_source.value.values
      name   = attachments_source.value.name
    }
  }

  permissions = var.permissions != null ? var.permissions : null
}