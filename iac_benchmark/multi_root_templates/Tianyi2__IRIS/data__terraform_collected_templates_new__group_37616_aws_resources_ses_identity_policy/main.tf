resource "aws_ses_identity_policy" "this" {
  region   = var.region
  identity = var.identity
  name     = var.name
  policy   = var.policy
}