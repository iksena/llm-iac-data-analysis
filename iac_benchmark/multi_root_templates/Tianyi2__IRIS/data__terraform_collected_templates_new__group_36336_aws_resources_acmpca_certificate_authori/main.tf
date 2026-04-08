resource "aws_acmpca_certificate_authority" "this" {
  region                          = var.region
  enabled                         = var.enabled
  type                            = var.type
  usage_mode                      = var.usage_mode
  key_storage_security_standard   = var.key_storage_security_standard
  permanent_deletion_time_in_days = var.permanent_deletion_time_in_days
  tags                            = var.tags

  certificate_authority_configuration {
    key_algorithm     = var.key_algorithm
    signing_algorithm = var.signing_algorithm

    subject {
      common_name                  = var.common_name
      country                      = var.country
      distinguished_name_qualifier = var.distinguished_name_qualifier
      generation_qualifier         = var.generation_qualifier
      given_name                   = var.given_name
      initials                     = var.initials
      locality                     = var.locality
      organization                 = var.organization
      organizational_unit          = var.organizational_unit
      pseudonym                    = var.pseudonym
      state                        = var.state
      surname                      = var.surname
      title                        = var.title
    }
  }

  dynamic "revocation_configuration" {
    for_each = var.revocation_configuration != null ? [var.revocation_configuration] : []
    content {
      dynamic "crl_configuration" {
        for_each = revocation_configuration.value.crl_configuration != null ? [revocation_configuration.value.crl_configuration] : []
        content {
          custom_cname       = crl_configuration.value.custom_cname
          enabled            = crl_configuration.value.enabled
          expiration_in_days = crl_configuration.value.expiration_in_days
          s3_bucket_name     = crl_configuration.value.s3_bucket_name
          s3_object_acl      = crl_configuration.value.s3_object_acl
        }
      }

      dynamic "ocsp_configuration" {
        for_each = revocation_configuration.value.ocsp_configuration != null ? [revocation_configuration.value.ocsp_configuration] : []
        content {
          enabled           = ocsp_configuration.value.enabled
          ocsp_custom_cname = ocsp_configuration.value.ocsp_custom_cname
        }
      }
    }
  }

  timeouts {
    create = var.timeouts_create
  }
}