resource "aws_cognito_managed_login_branding" "this" {
  client_id                    = var.client_id
  user_pool_id                 = var.user_pool_id
  region                       = var.region
  settings                     = var.settings
  use_cognito_provided_values  = var.use_cognito_provided_values

  dynamic "asset" {
    for_each = var.asset != null ? var.asset : []
    content {
      bytes       = asset.value.bytes
      category    = asset.value.category
      color_mode  = asset.value.color_mode
      extensions  = asset.value.extensions
      resource_id = asset.value.resource_id
    }
  }
}