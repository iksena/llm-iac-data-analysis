data "aws_connect_instance_storage_config" "this" {
  association_id = var.association_id
  instance_id    = var.instance_id
  resource_type  = var.resource_type
  region         = var.region
}