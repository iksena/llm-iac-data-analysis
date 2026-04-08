data "aws_quicksight_group" "this" {
  group_name     = var.group_name
  aws_account_id = var.aws_account_id
  namespace      = var.namespace
  region         = var.region
}