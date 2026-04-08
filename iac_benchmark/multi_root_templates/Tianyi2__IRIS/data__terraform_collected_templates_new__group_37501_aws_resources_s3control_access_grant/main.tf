resource "aws_s3control_access_grant" "this" {
  region                    = var.region
  access_grants_location_id = var.access_grants_location_id
  account_id                = var.account_id
  permission                = var.permission
  s3_prefix_type            = var.s3_prefix_type
  tags                      = var.tags

  dynamic "access_grants_location_configuration" {
    for_each = var.access_grants_location_configuration != null ? [var.access_grants_location_configuration] : []
    content {
      s3_sub_prefix = access_grants_location_configuration.value.s3_sub_prefix
    }
  }

  dynamic "grantee" {
    for_each = var.grantee != null ? [var.grantee] : []
    content {
      grantee_identifier = grantee.value.grantee_identifier
      grantee_type       = grantee.value.grantee_type
    }
  }
}