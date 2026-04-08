resource "aws_lexv2models_bot" "this" {
  name        = var.name
  description = var.description

  data_privacy {
    child_directed = var.data_privacy.child_directed
  }

  idle_session_ttl_in_seconds = var.idle_session_ttl_in_seconds
  role_arn                    = var.role_arn
  type                        = var.type
  region                      = var.region

  dynamic "members" {
    for_each = var.members != null ? var.members : []
    content {
      alias_id   = members.value.alias_id
      alias_name = members.value.alias_name
      id         = members.value.id
      name       = members.value.name
      version    = members.value.version
    }
  }

  tags                = var.tags
  test_bot_alias_tags = var.test_bot_alias_tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}