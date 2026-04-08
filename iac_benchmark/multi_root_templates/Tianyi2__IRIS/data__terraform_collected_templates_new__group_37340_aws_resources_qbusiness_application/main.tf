resource "aws_qbusiness_application" "this" {
  display_name                 = var.display_name
  iam_service_role_arn         = var.iam_service_role_arn
  identity_center_instance_arn = var.identity_center_instance_arn

  attachments_configuration {
    attachments_control_mode = var.attachments_configuration.attachments_control_mode
  }

  description = var.description
  region      = var.region

  dynamic "encryption_configuration" {
    for_each = var.encryption_configuration != null ? [var.encryption_configuration] : []
    content {
      kms_key_id = encryption_configuration.value.kms_key_id
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}