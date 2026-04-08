resource "aws_iam_user_policies_exclusive" "this" {
  user_name    = var.user_name
  policy_names = var.policy_names
}