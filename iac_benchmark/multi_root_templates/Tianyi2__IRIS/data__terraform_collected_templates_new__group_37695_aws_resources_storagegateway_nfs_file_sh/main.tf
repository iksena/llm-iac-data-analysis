resource "aws_storagegateway_nfs_file_share" "this" {
  region                  = var.region
  client_list             = var.client_list
  gateway_arn             = var.gateway_arn
  location_arn            = var.location_arn
  role_arn                = var.role_arn
  vpc_endpoint_dns_name   = var.vpc_endpoint_dns_name
  bucket_region           = var.bucket_region
  audit_destination_arn   = var.audit_destination_arn
  default_storage_class   = var.default_storage_class
  guess_mime_type_enabled = var.guess_mime_type_enabled
  kms_encrypted           = var.kms_encrypted
  kms_key_arn             = var.kms_key_arn
  object_acl              = var.object_acl
  read_only               = var.read_only
  requester_pays          = var.requester_pays
  squash                  = var.squash
  file_share_name         = var.file_share_name
  notification_policy     = var.notification_policy
  tags                    = var.tags

  dynamic "nfs_file_share_defaults" {
    for_each = var.nfs_file_share_defaults != null ? [var.nfs_file_share_defaults] : []
    content {
      directory_mode = nfs_file_share_defaults.value.directory_mode
      file_mode      = nfs_file_share_defaults.value.file_mode
      group_id       = nfs_file_share_defaults.value.group_id
      owner_id       = nfs_file_share_defaults.value.owner_id
    }
  }

  dynamic "cache_attributes" {
    for_each = var.cache_attributes != null ? [var.cache_attributes] : []
    content {
      cache_stale_timeout_in_seconds = cache_attributes.value.cache_stale_timeout_in_seconds
    }
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}