module "deployment" {
  source = "../../modules/github-actions-iam"

  role_name = "VengefulProdDeploymentRole"
  repository_scope = [
    "repo:dotkom/vengeful-vineyard:*"
  ]
}

data "aws_iam_policy_document" "deployment" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:ListBucket",
      "s3:DeleteObject",
    ]
    effect = "Allow"
    resources = [
      module.vengeful_vineyard_bucket.bucket_arn,
      "${module.vengeful_vineyard_bucket.bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation",
    ]
    effect = "Allow"
    resources = [
      module.vengeful_vineyard_bucket.cloudfront_distribution_arn,
    ]
  }
}

resource "aws_iam_policy" "deployment" {
  name   = "VengefulProdDeploymentPolicy"
  policy = data.aws_iam_policy_document.deployment.json
}

resource "aws_iam_role_policy_attachment" "deployment" {
  policy_arn = aws_iam_policy.deployment.arn
  role       = module.deployment.role.name
}
