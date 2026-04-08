resource "aws_finspace_kx_database" "this" {
  environment_id = var.environment_id
  name           = var.name
  region         = var.region
  description    = var.description
  tags           = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}