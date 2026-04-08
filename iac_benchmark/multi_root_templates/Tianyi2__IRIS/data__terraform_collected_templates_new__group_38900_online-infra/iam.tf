resource "aws_iam_group" "appkom" {
  name = "Appkom"
}

# TODO: Consider if they want separate users for separate people
resource "aws_iam_user" "appkom" {
  name = "appkom"
}

resource "aws_iam_policy" "appkom" {
  name   = "AppkomGlobalPermissions"
  policy = data.aws_iam_policy_document.appkom.json
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy_document" "appkom" {
  statement {
    actions = [
      "ses:SendEmail",
      "ses:SendRawEmail"
    ]
    effect = "Allow"
    resources = [
      "arn:aws:ses:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:identity/online.ntnu.no"
    ]
  }
}

resource "aws_iam_policy_attachment" "appkom" {
  name       = "AppkomGlobalPermissions"
  policy_arn = aws_iam_policy.appkom.arn
  groups     = [aws_iam_group.appkom.name]
}

resource "aws_iam_user_group_membership" "appkom_appkom" {
  user = aws_iam_user.appkom.name
  groups = [
    aws_iam_group.appkom.name
  ]
}

resource "aws_iam_access_key" "appkom" {
  user = aws_iam_user.appkom.id
}
