resource "aws_sesv2_account_suppression_attributes" "this" {
  region             = var.region
  suppressed_reasons = var.suppressed_reasons
}