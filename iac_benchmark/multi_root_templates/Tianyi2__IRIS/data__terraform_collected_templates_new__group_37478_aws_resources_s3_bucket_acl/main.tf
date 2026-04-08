resource "aws_s3_bucket_acl" "this" {
  region                = var.region
  acl                   = var.acl
  bucket                = var.bucket
  expected_bucket_owner = var.expected_bucket_owner

  dynamic "access_control_policy" {
    for_each = var.access_control_policy != null ? [var.access_control_policy] : []
    content {
      dynamic "grant" {
        for_each = access_control_policy.value.grants
        content {
          permission = grant.value.permission

          grantee {
            email_address = grant.value.grantee.email_address
            id            = grant.value.grantee.id
            type          = grant.value.grantee.type
            uri           = grant.value.grantee.uri
          }
        }
      }

      owner {
        id           = access_control_policy.value.owner.id
        display_name = access_control_policy.value.owner.display_name
      }
    }
  }
}