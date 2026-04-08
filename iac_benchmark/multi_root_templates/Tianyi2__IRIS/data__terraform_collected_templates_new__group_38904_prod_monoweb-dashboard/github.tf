module "dashboard_ci" {
  source = "../../modules/github-actions-iam"

  role_name = "monoweb-prd-dashboard-ci-role"
  repository_scope = [
    "repo:dotkom/monoweb:*"
  ]
}

data "aws_iam_policy_document" "dashboard_ci_role" {
  source_policy_documents = [
    module.server_ecr_image.deployment_permission_set.json,
    module.dashboard_evergreen_service.deployment_permission_set.json,
  ]
}

resource "aws_iam_policy" "dashboard_ci_role" {
  name   = "monoweb-prd-dashboard-ci-policy"
  policy = data.aws_iam_policy_document.dashboard_ci_role.json
}

resource "aws_iam_role_policy_attachment" "dashboard_ci_role" {
  policy_arn = aws_iam_policy.dashboard_ci_role.arn
  role       = module.dashboard_ci.role.name
}

