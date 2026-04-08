resource "aws_ses_receipt_filter" "this" {
  region = var.region
  name   = var.name
  cidr   = var.cidr
  policy = var.policy
}