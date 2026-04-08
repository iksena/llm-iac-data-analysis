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

  step_name             = "${module.common.pipeline_name}-ecr"
  build_core_policy_arn = module.common.policy_build_core_arn
  ecr_url               = var.ecr_url
  ecr_arn               = var.ecr_arn

  vpc_config               = var.vpc_config
  agent_security_group_ids = [var.agent_security_group_ids.service_endpoints]

  tags = var.tags
}

module "docker_deployment_sandbox" {
  source = "../docker_deployment_step"

  step_name             = "${module.common.pipeline_name}-deploy-sandbox"
  build_core_policy_arn = module.common.policy_build_core_arn
  lambda_arn            = "arn:aws:lambda:${var.target_region}:${var.accounts.sandbox.id}:function:${var.lambda_function_name}"
  ecr_url               = var.ecr_url
  deployment_role_arn   = var.accounts.sandbox.role_arns["lambda-deploy"]

  vpc_config               = var.vpc_config
  agent_security_group_ids = [var.agent_security_group_ids.service_endpoints]

  tags = var.tags
}
