resource "aws_iam_group_policies_exclusive" "this" {
  group_name   = var.group_name
  policy_names = var.policy_names
}