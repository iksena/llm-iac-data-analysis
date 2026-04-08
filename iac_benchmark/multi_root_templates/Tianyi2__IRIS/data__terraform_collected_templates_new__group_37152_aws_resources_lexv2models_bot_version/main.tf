resource "aws_lexv2models_bot_version" "this" {
  bot_id               = var.bot_id
  locale_specification = var.locale_specification
  description          = var.description
  region               = var.region

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}