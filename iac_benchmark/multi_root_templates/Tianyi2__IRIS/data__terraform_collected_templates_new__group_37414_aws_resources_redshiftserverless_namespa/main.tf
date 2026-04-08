locals {
  admin_password_conflicts = [
    var.admin_user_password != null ? 1 : 0,
    var.admin_user_password_wo != null ? 1 : 0,
    var.manage_admin_password != null ? 1 : 0
  ]
  admin_password_count = sum(local.admin_password_conflicts)
}

resource "aws_redshiftserverless_namespace" "this" {
  lifecycle {
    precondition {
      condition     = local.admin_password_count <= 1
      error_message = "Only one of admin_user_password, admin_user_password_wo, or manage_admin_password can be specified."
    }
  }
  region                           = var.region
  admin_password_secret_kms_key_id = var.admin_password_secret_kms_key_id
  admin_user_password              = var.admin_user_password
  admin_user_password_wo           = var.admin_user_password_wo
  admin_user_password_wo_version   = var.admin_user_password_wo_version
  admin_username                   = var.admin_username
  db_name                          = var.db_name
  default_iam_role_arn             = var.default_iam_role_arn
  iam_roles                        = var.iam_roles
  kms_key_id                       = var.kms_key_id
  log_exports                      = var.log_exports
  namespace_name                   = var.namespace_name
  manage_admin_password            = var.manage_admin_password
  tags                             = var.tags
}