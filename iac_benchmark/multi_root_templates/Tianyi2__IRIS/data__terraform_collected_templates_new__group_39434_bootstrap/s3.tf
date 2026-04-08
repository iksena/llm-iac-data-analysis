data "aws_caller_identity" "current" {}

locals {

  tf_readers = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleProwlerScanner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformPlanner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleSecurityEngineer"
  ]
  tf_writers     = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier"]
  tf_admin_roles = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier"]


  cf_templates_readers = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleProwlerScanner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformPlanner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleSecurityEngineer",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleChangeSetCreator",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleIAMAdministrator",
  ]

  cf_templates_writers = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier",
  ]

  tf_state_bucket_name    = "platsec-ci20210713082841419000000002"
  access_logs_bucket_name = "platsec-ci-access-logs20220222104748703700000001"
}

module "access_logs" {
  source      = "../modules/access_logs_bucket"
  bucket_name = local.access_logs_bucket_name
  admin_roles = local.tf_admin_roles
  read_roles  = local.tf_readers
}

module "state_bucket" {
  source        = "hmrc/s3-bucket-standard/aws"
  version       = "3.0.2"
  bucket_name   = local.tf_state_bucket_name
  force_destroy = false

  list_roles          = local.tf_readers
  read_roles          = local.tf_readers
  metadata_read_roles = local.tf_readers
  write_roles         = local.tf_writers
  admin_roles         = local.tf_admin_roles

  data_expiry      = "forever-config-only"
  data_sensitivity = "high"

  log_bucket_id = module.access_logs.bucket_id
}

module "cf_templates_bucket" {
  source        = "hmrc/s3-bucket-standard/aws"
  version       = "3.0.2"
  bucket_name   = "cf-templates-1a94pgui3v5ft-eu-west-2"
  force_destroy = false

  list_roles          = local.cf_templates_readers
  read_roles          = local.cf_templates_readers
  metadata_read_roles = local.cf_templates_readers
  write_roles         = local.cf_templates_writers
  admin_roles         = local.tf_admin_roles

  data_expiry      = "90-days"
  data_sensitivity = "low"

  log_bucket_id = module.access_logs.bucket_id
}

resource "aws_s3_account_public_access_block" "this" {
  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}


