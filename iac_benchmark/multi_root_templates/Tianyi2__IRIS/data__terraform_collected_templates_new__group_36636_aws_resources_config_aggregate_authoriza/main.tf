resource "aws_config_aggregate_authorization" "this" {
  account_id            = var.account_id
  authorized_aws_region = var.authorized_aws_region
  tags                  = var.tags
}