resource "aws_networkmanager_attachment_accepter" "this" {
  attachment_id   = var.attachment_id
  attachment_type = var.attachment_type

  timeouts {
    create = var.create_timeout
  }
}