resource "aws_redshift_usage_limit" "this" {
  region             = var.region
  amount             = var.amount
  breach_action      = var.breach_action
  cluster_identifier = var.cluster_identifier
  feature_type       = var.feature_type
  limit_type         = var.limit_type
  period             = var.period
  tags               = var.tags
}