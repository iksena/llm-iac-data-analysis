data "aws_iam_openid_connect_provider" "this" {
  arn = var.arn
  url = var.url
}