resource "aws_storagegateway_cache" "this" {
  region      = var.region
  disk_id     = var.disk_id
  gateway_arn = var.gateway_arn
}