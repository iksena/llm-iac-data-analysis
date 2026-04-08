resource "aws_iam_user_policy_attachments_exclusive" "this" {
  user_name   = var.user_name
  policy_arns = var.policy_arns
}