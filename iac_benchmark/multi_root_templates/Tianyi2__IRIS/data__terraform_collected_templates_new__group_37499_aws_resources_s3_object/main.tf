resource "aws_s3_object" "this" {
  bucket = var.bucket
  key    = var.key

  acl                           = var.acl
  bucket_key_enabled            = var.bucket_key_enabled
  cache_control                 = var.cache_control
  checksum_algorithm            = var.checksum_algorithm
  content_base64                = var.content_base64
  content_disposition           = var.content_disposition
  content_encoding              = var.content_encoding
  content_language              = var.content_language
  content_type                  = var.content_type
  content                       = var.content
  etag                          = var.etag
  force_destroy                 = var.force_destroy
  kms_key_id                    = var.kms_key_id
  metadata                      = var.metadata
  object_lock_legal_hold_status = var.object_lock_legal_hold_status
  object_lock_mode              = var.object_lock_mode
  object_lock_retain_until_date = var.object_lock_retain_until_date
  server_side_encryption        = var.server_side_encryption
  source_hash                   = var.source_hash
  source                        = var.source_file
  storage_class                 = var.storage_class
  region                        = var.region
  tags                          = var.tags
  website_redirect              = var.website_redirect

  dynamic "override_provider" {
    for_each = var.override_provider != null ? [var.override_provider] : []
    content {
      dynamic "default_tags" {
        for_each = override_provider.value.default_tags != null ? [override_provider.value.default_tags] : []
        content {
          tags = default_tags.value.tags
        }
      }
    }
  }
}