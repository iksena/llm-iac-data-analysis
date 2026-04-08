resource "aws_ssoadmin_application" "this" {
  application_provider_arn = var.application_provider_arn
  instance_arn             = var.instance_arn
  name                     = var.name

  region       = var.region
  client_token = var.client_token
  description  = var.description
  status       = var.status
  tags         = var.tags

  dynamic "portal_options" {
    for_each = var.portal_options != null ? [var.portal_options] : []
    content {
      visibility = portal_options.value.visibility

      dynamic "sign_in_options" {
        for_each = portal_options.value.sign_in_options != null ? [portal_options.value.sign_in_options] : []
        content {
          application_url = sign_in_options.value.application_url
          origin          = sign_in_options.value.origin
        }
      }
    }
  }
}