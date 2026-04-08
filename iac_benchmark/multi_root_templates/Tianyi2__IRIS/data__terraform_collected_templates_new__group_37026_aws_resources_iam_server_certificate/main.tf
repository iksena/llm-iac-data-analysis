resource "aws_iam_server_certificate" "this" {
  certificate_body  = var.certificate_body
  certificate_chain = var.certificate_chain
  name              = var.name
  name_prefix       = var.name_prefix
  path              = var.path
  private_key       = var.private_key
  tags              = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      delete = timeouts.value.delete
    }
  }
}