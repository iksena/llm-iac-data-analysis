resource "aws_cloudfront_field_level_encryption_config" "this" {
  comment = var.comment

  content_type_profile_config {
    forward_when_content_type_is_unknown = var.content_type_profile_config.forward_when_content_type_is_unknown

    content_type_profiles {
      dynamic "items" {
        for_each = var.content_type_profile_config.content_type_profiles.items
        content {
          content_type = items.value.content_type
          format       = items.value.format
          profile_id   = items.value.profile_id
        }
      }
    }
  }

  query_arg_profile_config {
    forward_when_query_arg_profile_is_unknown = var.query_arg_profile_config.forward_when_query_arg_profile_is_unknown

    dynamic "query_arg_profiles" {
      for_each = var.query_arg_profile_config.query_arg_profiles != null ? [var.query_arg_profile_config.query_arg_profiles] : []
      content {
        dynamic "items" {
          for_each = query_arg_profiles.value.items
          content {
            profile_id = items.value.profile_id
            query_arg  = items.value.query_arg
          }
        }
      }
    }
  }
}