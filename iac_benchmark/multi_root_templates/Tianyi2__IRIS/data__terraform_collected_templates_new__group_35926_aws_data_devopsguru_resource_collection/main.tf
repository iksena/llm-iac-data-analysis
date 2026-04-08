data "aws_devopsguru_resource_collection" "this" {
  region = var.region
  type   = var.type
}