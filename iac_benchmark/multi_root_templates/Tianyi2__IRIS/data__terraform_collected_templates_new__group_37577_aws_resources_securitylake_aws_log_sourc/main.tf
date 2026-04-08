resource "aws_securitylake_aws_log_source" "this" {
  region = var.region

  source {
    accounts       = var.source_accounts
    regions        = var.source_regions
    source_name    = var.source_name
    source_version = var.source_version
  }
}