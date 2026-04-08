data "aws_iam_policy_document" "this" {
  dynamic "statement" {
    for_each = var.assumable_roles
    content {
      actions = [
        "sts:AssumeRole"
      ]
      resources = [statement.value]
    }
  }
}

resource "aws_iam_policy" "this" {
  name_prefix = "${var.src_repo}-assumable-roles-"
  description = "The ${var.src_repo} codebuild project assumable roles"

  policy = data.aws_iam_policy_document.this.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Step = "${var.src_repo}-terraform-ci"
  }, var.tags)
}

resource "aws_iam_role_policy_attachment" "this" {
  for_each = toset(var.environments)

  role       = module.pr_plan[each.value].aws_iam_role_name
  policy_arn = aws_iam_policy.this.arn
  depends_on = [module.pr_plan]
}