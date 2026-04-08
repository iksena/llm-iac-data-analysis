resource "aws_lex_slot_type" "this" {
  name = var.name
  dynamic "enumeration_value" {
    for_each = var.enumeration_value
    content {
      value    = enumeration_value.value.value
      synonyms = enumeration_value.value.synonyms
    }
  }
  create_version           = var.create_version
  description              = var.description
  value_selection_strategy = var.value_selection_strategy

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}