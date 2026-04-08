resource "aws_storagegateway_smb_file_share" "this" {
  region                   = var.region
  gateway_arn              = var.gateway_arn
  location_arn             = var.location_arn
  vpc_endpoint_dns_name    = var.vpc_endpoint_dns_name
  bucket_region            = var.bucket_region
  role_arn                 = var.role_arn
  admin_user_list          = var.admin_user_list
  authentication           = var.authentication
  audit_destination_arn    = var.audit_destination_arn
  default_storage_class    = var.default_storage_class
  file_share_name          = var.file_share_name
  guess_mime_type_enabled  = var.guess_mime_type_enabled
  invalid_user_list        = var.invalid_user_list
  kms_encrypted            = var.kms_encrypted
  kms_key_arn              = var.kms_key_arn
  object_acl               = var.object_acl
  oplocks_enabled          = var.oplocks_enabled
  read_only                = var.read_only
  requester_pays           = var.requester_pays
  smb_acl_enabled          = var.smb_acl_enabled
  case_sensitivity         = var.case_sensitivity
  valid_user_list          = var.valid_user_list
  access_based_enumeration = var.access_based_enumeration
  notification_policy      = var.notification_policy
  tags                     = var.tags

  dynamic "cache_attributes" {
    for_each = var.cache_attributes != null ? [var.cache_attributes] : []
    content {
      cache_stale_timeout_in_seconds = cache_attributes.value.cache_stale_timeout_in_seconds
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}