resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  for_each   = var.role_policy_attachment_arns
  policy_arn = each.value
  role       = aws_iam_role.role.id
}
