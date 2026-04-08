resource "aws_transfer_certificate" "this" {
  certificate       = var.certificate
  certificate_chain = var.certificate_chain
  description       = var.description
  private_key       = var.private_key
  tags              = var.tags
  usage             = var.usage
}