resource "aws_sesv2_email_identity" "this" {
  email_identity         = var.email_identity
  region                 = var.region
  configuration_set_name = var.configuration_set_name
  tags                   = var.tags

  dynamic "dkim_signing_attributes" {
    for_each = var.dkim_signing_attributes != null ? [var.dkim_signing_attributes] : []
    content {
      domain_signing_private_key = dkim_signing_attributes.value.domain_signing_private_key
      domain_signing_selector    = dkim_signing_attributes.value.domain_signing_selector
      next_signing_key_length    = dkim_signing_attributes.value.next_signing_key_length
    }
  }
}