resource "aws_transfer_tag" "this" {
  region       = var.region
  resource_arn = var.resource_arn
  key          = var.key
  value        = var.value
}