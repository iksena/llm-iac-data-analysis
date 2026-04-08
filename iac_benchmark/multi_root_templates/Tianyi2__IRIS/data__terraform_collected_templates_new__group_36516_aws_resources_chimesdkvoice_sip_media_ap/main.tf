resource "aws_chimesdkvoice_sip_media_application" "this" {
  aws_region = var.aws_region
  name       = var.name
  region     = var.region
  tags       = var.tags

  dynamic "endpoints" {
    for_each = var.endpoints
    content {
      lambda_arn = endpoints.value.lambda_arn
    }
  }
}