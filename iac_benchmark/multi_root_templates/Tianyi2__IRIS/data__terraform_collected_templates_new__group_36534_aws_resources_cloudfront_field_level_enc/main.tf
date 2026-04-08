resource "aws_cloudfront_field_level_encryption_profile" "this" {
  name    = var.name
  comment = var.comment

  encryption_entities {
    items {
      public_key_id = var.public_key_id
      provider_id   = var.provider_id

      field_patterns {
        items = var.field_pattern_items
      }
    }
  }
}