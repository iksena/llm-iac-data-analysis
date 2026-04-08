module "pull_request_builder" {
  source = "../modules//pull_request_builder"

  project_name = "${local.repo}-pr-builder"
  project_assume_roles = {
    "TERRAFORM_PLANNER_ROLE_ARN" = local.terraform_planner_role
  }

  docker_required = true

  codeconnection_arn = data.aws_codestarconnections_connection.this.arn
  src_repo           = local.repo
  src_branch         = ""
  buildspec          = "platsec_ci_terraform_plan.yaml"

  vpc_config = module.networking.vpc_config
  agent_security_group_ids = {
    internet          = module.networking.ci_agent_to_internet_sg_id
    service_endpoints = module.networking.ci_agent_to_endpoints_sg_id
  }

  timeout_in_minutes = 30
}