module "build_artifact_step" {
  source = "../build_artifact_step"

  docker_required = true
  step_name       = "${module.common.pipeline_name}-build"

  s3_bucket_arn            = module.common.bucket_arn
  vpc_config               = var.vpc_config
  agent_security_group_ids = values(var.agent_security_group_ids)
  policy_arns              = [module.common.policy_build_core_arn]

  tags = var.tags
}

module "build_timestamp_step" {
  source      = "../build_timestamp_step"
  step_name   = "${module.common.pipeline_name}-timestamp"
  policy_arns = [module.common.policy_build_core_arn]

  tags = var.tags
}

module "upload_to_ecr" {
  source = "../upload_to_ci_ecr_step"

  step_name                = "${module.common.pipeline_name}-ecr"
  build_core_policy_arn    = module.common.policy_build_core_arn
  ecr_url                  = var.ecr_url
  ecr_arn                  = var.ecr_arn
  vpc_config               = var.vpc_config
  agent_security_group_ids = [var.agent_security_group_ids.service_endpoints]

  tags = var.tags
}

module "docker_deployment_development" {
  source = "../update_task_definition_step"

  step_name             = "${module.common.pipeline_name}-deploy-development"
  build_core_policy_arn = module.common.policy_build_core_arn
  deployment_role_arn   = var.accounts.development.role_arns["ecs-task-update"]
  ecr_url               = var.ecr_url
  task_name             = var.task_name
  service_name          = var.service_name
  cluster_name          = var.cluster_name

  vpc_config               = var.vpc_config
  agent_security_group_ids = [var.agent_security_group_ids.service_endpoints]

  tags = var.tags
}

module "docker_deployment_production" {
  source = "../update_task_definition_step"

  step_name             = "${module.common.pipeline_name}-deploy-production"
  build_core_policy_arn = module.common.policy_build_core_arn
  deployment_role_arn   = var.accounts.production.role_arns["ecs-task-update"]
  ecr_url               = var.ecr_url
  task_name             = var.task_name
  service_name          = var.service_name
  cluster_name          = var.cluster_name

  vpc_config               = var.vpc_config
  agent_security_group_ids = [var.agent_security_group_ids.service_endpoints]

  tags = var.tags
}
