resource "aws_iam_group_policy_attachments_exclusive" "this" {
  group_name  = var.group_name
  policy_arns = var.policy_arns
}