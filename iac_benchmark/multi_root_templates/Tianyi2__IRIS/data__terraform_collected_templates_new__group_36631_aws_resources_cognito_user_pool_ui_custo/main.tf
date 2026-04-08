resource "aws_cognito_user_pool_ui_customization" "this" {
  region       = var.region
  client_id    = var.client_id
  css          = var.css
  image_file   = var.image_file
  user_pool_id = var.user_pool_id

  lifecycle {
    precondition {
      condition     = var.css != null || var.image_file != null
      error_message = "At least one of css or image_file must be specified."
    }
  }
}