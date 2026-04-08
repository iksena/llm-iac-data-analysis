data "aws_synthetics_runtime_version" "this" {
  prefix  = var.prefix
  region  = var.region
  latest  = var.latest
  version = var.runtime_version
}