resource "aws_cloudwatch_log_data_protection_policy" "this" {
  region          = var.region
  log_group_name  = var.log_group_name
  policy_document = var.policy_document
}