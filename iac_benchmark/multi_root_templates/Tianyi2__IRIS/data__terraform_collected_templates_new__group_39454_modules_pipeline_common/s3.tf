locals {
  bucket_name = "ci-${substr(local.pipeline_name, 0, 32)}"
  readers = [
    # Allow all roles ReadOnly access since there is no specific naming convention for codepipeline/codebuild project roles
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformPlanner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleSecurityEngineer",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleProwlerScanner",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.pipeline_role_name}*",
  ]
  writers = [
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier",
    "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleSecurityEngineer",
  ]
  admins = concat(var.admin_roles, ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleKmsAdministrator"])
}

module "kms_key_policy_document" {
  source = "../kms_key_policy"

  read_roles  = local.readers
  write_roles = local.writers
  admin_roles = local.admins
}

module "codepipeline_bucket" {
  source         = "hmrc/s3-bucket-core/aws"
  version        = "3.0.1"
  bucket_name    = local.bucket_name
  force_destroy  = true
  kms_key_policy = module.kms_key_policy_document.policy_document_json

  data_expiry      = "90-days"
  data_sensitivity = "low"

  transition_to_glacier_days = var.transition_to_glacier_days

  log_bucket_id = var.access_log_bucket_id

  tags = merge({
    Pipeline = local.pipeline_name
  }, var.tags)
}

resource "aws_s3_bucket_policy" "bucket" {
  bucket = module.codepipeline_bucket.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {
    sid    = "DenyInsecureTransport"
    effect = "Deny"
    principals {
      type        = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:*",
    ]
    resources = [
      module.codepipeline_bucket.arn,
      "${module.codepipeline_bucket.arn}/*",
    ]
    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }
  }

  statement {
    sid    = "DenyAdminActivities"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:DeleteBucket*",
      "s3:GetAccelerateConfiguration",
      "s3:GetAnalyticsConfiguration",
      "s3:PutAccelerateConfiguration",
      "s3:PutAnalyticsConfiguration",
      "s3:PutBucket*",
      "s3:PutEncryptionConfiguration",
      "s3:PutInventoryConfiguration",
      "s3:PutLifecycleConfiguration",
      "s3:PutMetricsConfiguration",
      "s3:PutReplicationConfiguration",
    ]
    resources = [module.codepipeline_bucket.arn]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values   = var.admin_roles
    }
  }

  statement {
    sid    = "DenyActivitiesUnlessBucketAdmin"
    effect = "Deny"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetInventoryConfiguration",
      "s3:GetMetricsConfiguration",
      "s3:GetReplicationConfiguration",
    ]
    resources = [module.codepipeline_bucket.arn]
    condition {
      test     = "StringNotLike"
      variable = "aws:PrincipalArn"
      values   = concat(var.admin_roles, ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleProwlerScanner"])
    }
  }

  statement {
    sid    = "AllowReadOnlyProwlerScanner"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
    actions = [
      "s3:ListBucket*",
      "s3:GetObject*",
      "s3:GetBucket*",
      "s3:GetEncryptionConfiguration",
      "s3:GetInventoryConfiguration",
      "s3:GetLifecycleConfiguration",
      "s3:GetMetricsConfiguration",
      "s3:GetReplicationConfiguration"
    ]
    resources = [
      module.codepipeline_bucket.arn,
      "${module.codepipeline_bucket.arn}/*"
    ]
    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalArn"
      values   = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleProwlerScanner"]
    }
  }
}
