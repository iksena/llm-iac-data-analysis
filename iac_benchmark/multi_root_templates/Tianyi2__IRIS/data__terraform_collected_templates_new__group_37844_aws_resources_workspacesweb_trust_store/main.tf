resource "aws_workspacesweb_trust_store" "this" {
  region = var.region

  dynamic "certificate" {
    for_each = var.certificates
    content {
      body = certificate.value.body
    }
  }

  tags = var.tags
}