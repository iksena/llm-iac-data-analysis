resource "aws_storagegateway_upload_buffer" "this" {
  region      = var.region
  disk_id     = var.disk_id
  disk_path   = var.disk_path
  gateway_arn = var.gateway_arn
}