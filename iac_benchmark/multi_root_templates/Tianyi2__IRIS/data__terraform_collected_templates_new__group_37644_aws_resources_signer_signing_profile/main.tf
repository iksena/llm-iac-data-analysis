resource "aws_signer_signing_profile" "this" {
  region             = var.region
  platform_id        = var.platform_id
  name               = var.name
  name_prefix        = var.name_prefix
  signing_parameters = var.signing_parameters
  tags               = var.tags

  dynamic "signature_validity_period" {
    for_each = var.signature_validity_period != null ? [var.signature_validity_period] : []
    content {
      type  = signature_validity_period.value.type
      value = signature_validity_period.value.value
    }
  }

  dynamic "signing_material" {
    for_each = var.signing_material != null ? [var.signing_material] : []
    content {
      certificate_arn = signing_material.value.certificate_arn
    }
  }
}