module "iam_group_restricted_admin" {
  source  = "StratusGrid/iam-group-restricted-admin/aws"
  version = "1.2.2"
  # source  = "github.com/StratusGrid/terraform-aws-iam-group-restricted-admin"

  group_name = "${var.name_prefix}-restricted-admin"

  s3_bucket_paths_to_protect = [
    module.cloudtrail.s3_bucket_arn,
    "${module.cloudtrail.s3_bucket_arn}/*"
  ]

  input_tags = merge(local.common_tags, {})
}

module "iam_group_restricted_read_only" {
  source  = "StratusGrid/iam-group-restricted-read-only/aws"
  version = "1.1.1"
  # source  = "github.com/StratusGrid/terraform-aws-iam-group-restricted-read-only"

  group_name = "${var.name_prefix}-restricted-read-only"

  s3_bucket_paths_to_allow = [
    module.cloudtrail.s3_bucket_arn,
    "${module.cloudtrail.s3_bucket_arn}/*"
  ]

  input_tags = merge(local.common_tags, {})
}

