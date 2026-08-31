data "aws_iam_policy_document" "gh_actions" {
  provider = aws.eu_central_1
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]
    principals {
      type        = "Federated"
      identifiers = [var.github_oidc_arn]
    }
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = ["repo:utkusarioglu/utkusarioglu-com:*"]
    }
  }
}
