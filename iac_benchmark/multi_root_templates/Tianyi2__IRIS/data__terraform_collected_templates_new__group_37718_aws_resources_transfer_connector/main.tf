resource "aws_transfer_connector" "this" {
  region               = var.region
  access_role          = var.access_role
  url                  = var.url
  logging_role         = var.logging_role
  security_policy_name = var.security_policy_name
  tags                 = var.tags

  dynamic "as2_config" {
    for_each = var.as2_config != null ? [var.as2_config] : []
    content {
      compression           = as2_config.value.compression
      encryption_algorithm  = as2_config.value.encryption_algorithm
      local_profile_id      = as2_config.value.local_profile_id
      mdn_response          = as2_config.value.mdn_response
      mdn_signing_algorithm = as2_config.value.mdn_signing_algorithm
      message_subject       = as2_config.value.message_subject
      partner_profile_id    = as2_config.value.partner_profile_id
      signing_algorithm     = as2_config.value.signing_algorithm
    }
  }

  dynamic "sftp_config" {
    for_each = var.sftp_config != null ? [var.sftp_config] : []
    content {
      trusted_host_keys = sftp_config.value.trusted_host_keys
      user_secret_id    = sftp_config.value.user_secret_id
    }
  }
}