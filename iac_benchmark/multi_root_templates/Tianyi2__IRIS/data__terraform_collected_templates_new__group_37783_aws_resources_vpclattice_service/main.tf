resource "aws_vpclattice_service" "this" {
  name               = var.name
  region             = var.region
  auth_type          = var.auth_type
  certificate_arn    = var.certificate_arn
  custom_domain_name = var.custom_domain_name
  tags               = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}