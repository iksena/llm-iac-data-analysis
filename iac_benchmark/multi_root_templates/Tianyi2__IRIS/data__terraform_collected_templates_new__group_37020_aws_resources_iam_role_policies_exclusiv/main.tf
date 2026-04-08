resource "aws_iam_role_policies_exclusive" "this" {
  role_name    = var.role_name
  policy_names = var.policy_names
}