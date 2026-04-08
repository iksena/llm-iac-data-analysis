resource "aws_backup_selection" "this" {
  region        = var.region
  name          = var.name
  plan_id       = var.plan_id
  iam_role_arn  = var.iam_role_arn
  resources     = var.resources
  not_resources = var.not_resources

  dynamic "selection_tag" {
    for_each = var.selection_tag != null ? [var.selection_tag] : []
    content {
      type  = selection_tag.value.type
      key   = selection_tag.value.key
      value = selection_tag.value.value
    }
  }

  dynamic "condition" {
    for_each = var.condition != null ? [var.condition] : []
    content {
      dynamic "string_equals" {
        for_each = condition.value.string_equals != null ? [condition.value.string_equals] : []
        content {
          key   = string_equals.value.key
          value = string_equals.value.value
        }
      }

      dynamic "string_not_equals" {
        for_each = condition.value.string_not_equals != null ? [condition.value.string_not_equals] : []
        content {
          key   = string_not_equals.value.key
          value = string_not_equals.value.value
        }
      }

      dynamic "string_like" {
        for_each = condition.value.string_like != null ? [condition.value.string_like] : []
        content {
          key   = string_like.value.key
          value = string_like.value.value
        }
      }

      dynamic "string_not_like" {
        for_each = condition.value.string_not_like != null ? [condition.value.string_not_like] : []
        content {
          key   = string_not_like.value.key
          value = string_not_like.value.value
        }
      }
    }
  }
}