resource "aws_codecatalyst_project" "this" {
  space_name   = var.space_name
  display_name = var.display_name
  region       = var.region
  description  = var.description

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}