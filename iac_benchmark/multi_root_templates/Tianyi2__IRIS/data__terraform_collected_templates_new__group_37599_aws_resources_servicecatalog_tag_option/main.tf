resource "aws_servicecatalog_tag_option" "this" {
  key    = var.key
  value  = var.value
  region = var.region
  active = var.active

  timeouts {
    create = var.timeouts.create
    read   = var.timeouts.read
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}