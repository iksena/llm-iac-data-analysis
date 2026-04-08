resource "aws_evidently_feature" "this" {
  name                = var.name
  project             = var.project
  region              = var.region
  default_variation   = var.default_variation
  description         = var.description
  entity_overrides    = var.entity_overrides
  evaluation_strategy = var.evaluation_strategy
  tags                = var.tags

  dynamic "variations" {
    for_each = var.variations
    content {
      name = variations.value.name
      value {
        bool_value   = variations.value.value.bool_value
        double_value = variations.value.value.double_value
        long_value   = variations.value.value.long_value
        string_value = variations.value.value.string_value
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}