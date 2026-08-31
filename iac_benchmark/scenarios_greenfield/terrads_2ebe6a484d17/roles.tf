resource "aws_iam_role" "gh_actions" {
  provider           = aws.eu_central_1
  name               = "utkusarioglu-com-gh-actions"
  assume_role_policy = data.aws_iam_policy_document.gh_actions.json
  tags               = local.default_tags
}
