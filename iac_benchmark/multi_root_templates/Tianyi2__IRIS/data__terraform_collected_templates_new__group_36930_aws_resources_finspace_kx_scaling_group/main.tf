resource "aws_finspace_kx_scaling_group" "this" {
  availability_zone_id = var.availability_zone_id
  environment_id       = var.environment_id
  name                 = var.name
  host_type            = var.host_type

  region = var.region
  tags   = var.tags

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}