resource "aws_s3_object_copy" "this" {
  bucket = var.bucket
  key    = var.key
  source = var.source_key

  region                        = var.region
  acl                           = var.acl
  cache_control                 = var.cache_control
  checksum_algorithm            = var.checksum_algorithm
  content_disposition           = var.content_disposition
  content_encoding              = var.content_encoding
  content_language              = var.content_language
  content_type                  = var.content_type
  copy_if_match                 = var.copy_if_match
  copy_if_modified_since        = var.copy_if_modified_since
  copy_if_none_match            = var.copy_if_none_match
  copy_if_unmodified_since      = var.copy_if_unmodified_since
  customer_algorithm            = var.customer_algorithm
  customer_key                  = var.customer_key
  customer_key_md5              = var.customer_key_md5
  expected_bucket_owner         = var.expected_bucket_owner
  expected_source_bucket_owner  = var.expected_source_bucket_owner
  expires                       = var.expires
  force_destroy                 = var.force_destroy
  kms_encryption_context        = var.kms_encryption_context
  kms_key_id                    = var.kms_key_id
  metadata                      = var.metadata
  metadata_directive            = var.metadata_directive
  object_lock_legal_hold_status = var.object_lock_legal_hold_status
  object_lock_mode              = var.object_lock_mode
  object_lock_retain_until_date = var.object_lock_retain_until_date
  request_payer                 = var.request_payer
  server_side_encryption        = var.server_side_encryption
  source_customer_algorithm     = var.source_customer_algorithm
  source_customer_key           = var.source_customer_key
  source_customer_key_md5       = var.source_customer_key_md5
  storage_class                 = var.storage_class
  tagging_directive             = var.tagging_directive
  tags                          = var.tags
  website_redirect              = var.website_redirect

  dynamic "grant" {
    for_each = var.grant
    content {
      permissions = grant.value.permissions
      type        = grant.value.type
      email       = lookup(grant.value, "email", null)
      id          = lookup(grant.value, "id", null)
      uri         = lookup(grant.value, "uri", null)
    }
  }

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