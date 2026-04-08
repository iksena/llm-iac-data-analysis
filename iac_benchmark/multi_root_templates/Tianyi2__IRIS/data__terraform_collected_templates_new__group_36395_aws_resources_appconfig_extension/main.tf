resource "aws_appconfig_extension" "this" {
  name        = var.name
  description = var.description

  dynamic "action_point" {
    for_each = var.action_point
    content {
      point = action_point.value.point

      dynamic "action" {
        for_each = action_point.value.action
        content {
          name        = action.value.name
          uri         = action.value.uri
          role_arn    = action.value.role_arn
          description = action.value.description
        }
      }
    }
  }

  dynamic "parameter" {
    for_each = var.parameter
    content {
      name        = parameter.value.name
      required    = parameter.value.required
      description = parameter.value.description
    }
  }

  tags = var.tags
}