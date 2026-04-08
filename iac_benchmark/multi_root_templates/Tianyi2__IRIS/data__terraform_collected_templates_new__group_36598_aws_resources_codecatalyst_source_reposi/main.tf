resource "aws_codecatalyst_source_repository" "this" {
  name         = var.name
  space_name   = var.space_name
  project_name = var.project_name
  region       = var.region
  description  = var.description

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}