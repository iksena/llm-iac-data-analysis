resource "aws_securityhub_finding_aggregator" "this" {
  region            = var.region
  linking_mode      = var.linking_mode
  specified_regions = var.specified_regions
}