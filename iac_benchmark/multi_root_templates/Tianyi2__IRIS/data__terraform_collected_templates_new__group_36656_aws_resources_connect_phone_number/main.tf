resource "aws_connect_phone_number" "this" {
  region       = var.region
  country_code = var.country_code
  description  = var.description
  prefix       = var.prefix
  tags         = var.tags
  target_arn   = var.target_arn
  type         = var.type

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}