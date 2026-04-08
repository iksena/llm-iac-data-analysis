resource "aws_appfabric_app_authorization_connection" "this" {
  app_bundle_arn        = var.app_bundle_arn
  app_authorization_arn = var.app_authorization_arn
  region                = var.region

  dynamic "auth_request" {
    for_each = var.auth_request != null ? [var.auth_request] : []
    content {
      code         = auth_request.value.code
      redirect_uri = auth_request.value.redirect_uri
    }
  }

  timeouts {
    create = var.timeouts.create
  }
}