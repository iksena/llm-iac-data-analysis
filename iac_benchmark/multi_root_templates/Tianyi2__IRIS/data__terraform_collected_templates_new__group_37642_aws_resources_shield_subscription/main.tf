resource "aws_shield_subscription" "this" {
  auto_renew   = var.auto_renew
  skip_destroy = var.skip_destroy
}