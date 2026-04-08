provider "aws" {
  alias  = "region"
  region = var.region
}

resource "aws_apprunner_observability_configuration" "this" {
  provider = aws.region

  observability_configuration_name = var.observability_configuration_name

  dynamic "trace_configuration" {
    for_each = var.trace_configuration != null ? [var.trace_configuration] : []
    content {
      vendor = trace_configuration.value.vendor
    }
  }

  tags = var.tags
}