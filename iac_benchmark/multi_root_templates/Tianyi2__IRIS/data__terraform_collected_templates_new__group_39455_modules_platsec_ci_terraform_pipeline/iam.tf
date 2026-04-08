
data "aws_iam_policy_document" "secretsmanager" {
  statement {
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      data.aws_secretsmanager_secret_version.github_token.arn
    ]
  }
}

resource "aws_iam_policy" "secretsmanager" {
  name_prefix = substr(var.pipeline_name, 0, 32)
  description = "${var.pipeline_name} get secrets from secrets manager"
  policy      = data.aws_iam_policy_document.secretsmanager.json

  lifecycle {
    create_before_destroy = true
  }

  tags = merge({
    Pipeline = var.pipeline_name
  }, var.tags)
}
