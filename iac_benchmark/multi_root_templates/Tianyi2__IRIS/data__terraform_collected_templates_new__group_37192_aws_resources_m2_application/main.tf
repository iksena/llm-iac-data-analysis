resource "aws_m2_application" "this" {
  name        = var.name
  description = var.description
  engine_type = var.engine_type

  kms_key_id = var.kms_key_id
  role_arn   = var.role_arn
  tags       = var.tags

  dynamic "definition" {
    for_each = var.definition != null ? [var.definition] : []
    content {
      content     = definition.value.content
      s3_location = definition.value.s3_location
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}