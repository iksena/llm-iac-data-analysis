resource "aws_servicecatalog_portfolio" "this" {
  region        = var.region
  name          = var.name
  description   = var.description
  provider_name = var.provider_name
  tags          = var.tags

  timeouts {
    create = var.timeouts_create
    read   = var.timeouts_read
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}