resource "aws_codebuild_resource_policy" "this" {
  region       = var.region
  resource_arn = var.resource_arn
  policy       = var.policy
}