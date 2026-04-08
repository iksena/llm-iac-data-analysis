resource "aws_datazone_domain" "this" {
  name                  = var.name
  domain_execution_role = var.domain_execution_role

  region              = var.region
  description         = var.description
  domain_version      = var.domain_version
  kms_key_identifier  = var.kms_key_identifier
  service_role        = var.service_role
  skip_deletion_check = var.skip_deletion_check

  dynamic "single_sign_on" {
    for_each = var.single_sign_on != null ? [var.single_sign_on] : []
    content {
      type            = single_sign_on.value.type
      user_assignment = single_sign_on.value.user_assignment
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }

  tags = var.tags
}