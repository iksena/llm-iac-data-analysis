resource "aws_cloudwatch_log_account_policy" "this" {
  region             = var.region
  policy_document    = var.policy_document
  policy_type        = var.policy_type
  policy_name        = var.policy_name
  scope              = var.scope
  selection_criteria = var.selection_criteria
}