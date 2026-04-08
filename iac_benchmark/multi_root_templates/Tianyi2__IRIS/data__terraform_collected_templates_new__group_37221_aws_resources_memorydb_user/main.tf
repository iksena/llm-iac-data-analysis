resource "aws_memorydb_user" "this" {
  access_string = var.access_string
  user_name     = var.user_name
  region        = var.region
  tags          = var.tags

  authentication_mode {
    type      = var.authentication_mode.type
    passwords = var.authentication_mode.passwords
  }
}