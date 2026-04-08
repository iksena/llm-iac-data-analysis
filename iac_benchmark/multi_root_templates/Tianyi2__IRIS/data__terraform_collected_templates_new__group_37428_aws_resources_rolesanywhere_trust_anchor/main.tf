resource "aws_rolesanywhere_trust_anchor" "this" {
  enabled = var.enabled
  name    = var.name
  tags    = var.tags

  source {
    source_type = var.source_type

    source_data {
      acm_pca_arn           = var.acm_pca_arn
      x509_certificate_data = var.x509_certificate_data
    }
  }
}