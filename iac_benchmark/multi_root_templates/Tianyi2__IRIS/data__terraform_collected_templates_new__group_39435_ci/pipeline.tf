module "pipeline" {
  source = "../modules//platsec_ci_terraform_pipeline"

  pipeline_name = "${local.repo}-pipeline"
  src_repo      = local.repo
  branch        = "main"

  step_assume_roles = [
    {
      ci   = { "TERRAFORM_APPLIER_ROLE_ARN" = local.terraform_applier_role }
      live = { "TERRAFORM_APPLIER_ROLE_ARN" = local.terraform_applier_role }
    },
  ]
  admin_roles = [local.terraform_applier_role, local.terraform_planner_role]

  vpc_config = module.networking.vpc_config
  agent_security_group_ids = {
    internet          = module.networking.ci_agent_to_internet_sg_id
    service_endpoints = module.networking.ci_agent_to_endpoints_sg_id
  }
  sns_topic_arn        = module.ci_alerts_sns_topic.arn
  sns_kms_key_arn      = module.ci_alerts_sns_topic.kms_key_arn
  access_log_bucket_id = local.access_logs_bucket_name
  github_token         = data.aws_secretsmanager_secret_version.github_token.secret_string
  codeconnection_arn   = data.aws_codestarconnections_connection.this.arn

  step_timeout_in_minutes = 30
}
