locals {
  readers = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformPlanner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleSecurityEngineer",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleProwlerScanner",
  ]
  writers = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleSecurityEngineer",
  ]
  admins = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleKmsAdministrator",
  ]
}

module "kms_key_policy_document" {
  source = "../modules/kms_key_policy"

  read_roles  = local.readers
  write_roles = local.writers
  admin_roles = local.admins
}

resource "aws_kms_key" "terraform_key" {
  deletion_window_in_days = 7
  description             = "Key for assets created during bootstrap of ${var.boostrap_name}"
  enable_key_rotation     = true
  rotation_period_in_days = 90
  policy                  = module.kms_key_policy_document.policy_document_json
}

resource "aws_kms_alias" "terraform_key" {
  target_key_id = aws_kms_key.terraform_key.id
  name_prefix   = "alias/${var.boostrap_name}"
}
