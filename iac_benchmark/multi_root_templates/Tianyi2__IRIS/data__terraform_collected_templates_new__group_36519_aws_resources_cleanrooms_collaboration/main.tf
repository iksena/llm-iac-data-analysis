resource "aws_cleanrooms_collaboration" "this" {
  name                     = var.name
  description              = var.description
  creator_member_abilities = var.creator_member_abilities
  creator_display_name     = var.creator_display_name
  query_log_status         = var.query_log_status

  analytics_engine = var.analytics_engine

  dynamic "data_encryption_metadata" {
    for_each = var.data_encryption_metadata != null ? [var.data_encryption_metadata] : []
    content {
      allow_clear_text                            = data_encryption_metadata.value.allow_clear_text
      allow_duplicates                            = data_encryption_metadata.value.allow_duplicates
      allow_joins_on_columns_with_different_names = data_encryption_metadata.value.allow_joins_on_columns_with_different_names
      preserve_nulls                              = data_encryption_metadata.value.preserve_nulls
    }
  }

  dynamic "member" {
    for_each = var.members
    content {
      account_id       = member.value.account_id
      display_name     = member.value.display_name
      member_abilities = member.value.member_abilities
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}