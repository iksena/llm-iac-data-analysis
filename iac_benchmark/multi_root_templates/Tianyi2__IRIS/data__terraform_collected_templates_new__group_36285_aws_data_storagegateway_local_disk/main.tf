data "aws_storagegateway_local_disk" "this" {
  region      = var.region
  gateway_arn = var.gateway_arn
  disk_node   = var.disk_node
  disk_path   = var.disk_path
}