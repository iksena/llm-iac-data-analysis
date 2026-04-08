resource "aws_licensemanager_grant_accepter" "this" {
  region    = var.region
  grant_arn = var.grant_arn
}