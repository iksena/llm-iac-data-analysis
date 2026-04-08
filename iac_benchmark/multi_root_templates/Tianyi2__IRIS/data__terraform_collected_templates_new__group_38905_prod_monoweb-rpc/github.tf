module "rpc_ci" {
  source = "../../modules/github-actions-iam"

  role_name = "monoweb-prd-rpc-ci-role"
  repository_scope = [
    "repo:dotkom/monoweb:*"
  ]
}

data "aws_iam_policy_document" "rpc_ci_role" {
  source_policy_documents = [
    module.server_ecr_image.deployment_permission_set.json,
    module.rpc_evergreen_service.deployment_permission_set.json,
  ]
}

resource "aws_iam_policy" "rpc_ci_role" {
  name   = "monoweb-prd-rpc-ci-policy"
  policy = data.aws_iam_policy_document.rpc_ci_role.json
}

resource "aws_iam_role_policy_attachment" "rpc_ci_role" {
  policy_arn = aws_iam_policy.rpc_ci_role.arn
  role       = module.rpc_ci.role.name
}
