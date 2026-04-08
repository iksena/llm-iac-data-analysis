resource "aws_iam_organizations_features" "this" {
  enabled_features = var.enabled_features
}