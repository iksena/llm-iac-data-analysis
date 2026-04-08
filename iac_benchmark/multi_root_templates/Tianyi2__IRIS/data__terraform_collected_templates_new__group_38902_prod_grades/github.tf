module "server_ci" {
  source = "../../modules/github-actions-iam"

  role_name = "grades-prod-server-ci-role"
  repository_scope = [
    "repo:dotkom/gradestats:*",
  ]
}

module "web_ci" {
  source = "../../modules/github-actions-iam"

  role_name = "grades-prod-web-ci-role"
  repository_scope = [
    "repo:dotkom/gradestats-app:*",
  ]
}

data "aws_iam_policy_document" "web_ci_role" {
  source_policy_documents = [
    module.server_ecr_image.deployment_permission_set.json,
    module.web_ecr_image.deployment_permission_set.json,
  ]
}

resource "aws_iam_policy" "web_ci_policy" {
  name   = "grades-prod-web-ci-policy"
  policy = data.aws_iam_policy_document.web_ci_role.json
}

resource "aws_iam_role_policy_attachment" "web_ci_role" {
  policy_arn = aws_iam_policy.web_ci_policy.arn
  role       = module.web_ci.role.name
}
