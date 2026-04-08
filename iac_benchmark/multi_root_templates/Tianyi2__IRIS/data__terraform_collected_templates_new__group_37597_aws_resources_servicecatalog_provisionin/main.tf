resource "aws_servicecatalog_provisioning_artifact" "this" {
  product_id                  = var.product_id
  template_physical_id        = var.template_physical_id
  template_url                = var.template_url
  region                      = var.region
  accept_language             = var.accept_language
  active                      = var.active
  description                 = var.description
  disable_template_validation = var.disable_template_validation
  guidance                    = var.guidance
  name                        = var.name
  type                        = var.type

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}