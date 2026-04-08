resource "aws_iam_role_policy_attachments_exclusive" "this" {
  role_name   = var.role_name
  policy_arns = var.policy_arns
}