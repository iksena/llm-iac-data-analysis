resource "aws_codestarconnections_connection" "this" {
  region        = var.region
  name          = var.name
  provider_type = var.provider_type
  host_arn      = var.host_arn
  tags          = var.tags
}