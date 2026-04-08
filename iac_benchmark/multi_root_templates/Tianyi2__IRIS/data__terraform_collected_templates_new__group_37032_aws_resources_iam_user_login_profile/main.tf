resource "aws_iam_user_login_profile" "this" {
  user                    = var.user
  pgp_key                 = var.pgp_key
  password_length         = var.password_length
  password_reset_required = var.password_reset_required
}