resource "aws_amplify_domain_association" "this" {
  region                 = var.region
  app_id                 = var.app_id
  domain_name            = var.domain_name
  enable_auto_sub_domain = var.enable_auto_sub_domain
  wait_for_verification  = var.wait_for_verification

  dynamic "certificate_settings" {
    for_each = var.certificate_settings != null ? [var.certificate_settings] : []
    content {
      type                   = certificate_settings.value.type
      custom_certificate_arn = certificate_settings.value.custom_certificate_arn
    }
  }

  dynamic "sub_domain" {
    for_each = var.sub_domain
    content {
      branch_name = sub_domain.value.branch_name
      prefix      = sub_domain.value.prefix
    }
  }
}