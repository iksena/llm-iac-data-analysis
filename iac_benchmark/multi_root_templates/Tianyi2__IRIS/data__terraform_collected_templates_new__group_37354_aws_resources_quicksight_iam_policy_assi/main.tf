resource "aws_quicksight_iam_policy_assignment" "this" {
  assignment_name   = var.assignment_name
  assignment_status = var.assignment_status
  aws_account_id    = var.aws_account_id
  namespace         = var.namespace
  policy_arn        = var.policy_arn
  region            = var.region

  dynamic "identities" {
    for_each = var.identities != null ? [var.identities] : []
    content {
      group = identities.value.group
      user  = identities.value.user
    }
  }
}