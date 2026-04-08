resource "aws_costoptimizationhub_preferences" "this" {
  member_account_discount_visibility = var.member_account_discount_visibility
  savings_estimation_mode            = var.savings_estimation_mode
}