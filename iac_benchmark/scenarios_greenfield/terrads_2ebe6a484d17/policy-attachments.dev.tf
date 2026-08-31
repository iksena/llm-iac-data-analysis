resource "aws_iam_policy_attachment" "dev_state_store" {
  provider   = aws.eu_central_1
  name       = "utkusarioglu-com-dev-state-store"
  policy_arn = aws_iam_policy.dev_state_store.arn
  roles = [
    aws_iam_role.gh_actions.name
  ]
}

resource "aws_iam_policy_attachment" "dev_state_lock" {
  provider   = aws.eu_central_1
  name       = "utkusarioglu-com-dev-state-lock"
  policy_arn = aws_iam_policy.dev_state_lock.arn
  roles = [
    aws_iam_role.gh_actions.name
  ]
}

resource "aws_iam_policy_attachment" "dev_static_content_write" {
  provider   = aws.us_west_2
  name       = "utkusarioglu-com-dev-static-content-write"
  policy_arn = aws_iam_policy.dev_static_content_write.arn
  roles = [
    aws_iam_role.gh_actions.name
  ]
}

resource "aws_iam_policy_attachment" "cache_invalidate" {
  provider   = aws.us_west_2
  name       = "utkusarioglu-com-dev-cache-invalidate"
  policy_arn = aws_iam_policy.cache_invalidate.arn
  roles = [
    aws_iam_role.gh_actions.name
  ]
}
