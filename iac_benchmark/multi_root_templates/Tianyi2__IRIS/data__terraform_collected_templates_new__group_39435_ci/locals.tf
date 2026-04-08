
locals {
  repo                    = "platsec-ci-terraform"
  access_logs_bucket_name = "platsec-ci-access-logs20220222104748703700000001"
  terraform_applier_role  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformApplier"
  terraform_planner_role  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/RoleTerraformPlanner"
}
