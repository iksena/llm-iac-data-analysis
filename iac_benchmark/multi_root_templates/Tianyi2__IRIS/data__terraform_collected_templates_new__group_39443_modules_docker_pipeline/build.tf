module "build_artifact_step" {
  source = "../build_artifact_step"

  docker_required = true
  step_name       = "${module.common.pipeline_name}-build"

  s3_bucket_arn            = module.common.bucket_arn
  vpc_config               = var.vpc_config
  agent_security_group_ids = values(var.agent_security_group_ids)
  policy_arns              = [module.common.policy_build_core_arn]
  timeout_in_minutes       = var.build_timeout_in_minutes

  tags = var.tags
}

module "build_timestamp_step" {
  source      = "../build_timestamp_step"
  step_name   = "${module.common.pipeline_name}-timestamp"
  policy_arns = [module.common.policy_build_core_arn]
}
module "upload_to_ecr_step" {
  source = "../upload_to_ci_ecr_step"

  step_name             = "${module.common.pipeline_name}-ecr"
  build_core_policy_arn = module.common.policy_build_core_arn
  ecr_url               = var.ecr_url
  ecr_arn               = var.ecr_arn

  vpc_config                      = var.vpc_config
  agent_security_group_ids        = [var.agent_security_group_ids.service_endpoints]
  upload_image_timeout_in_minutes = var.upload_image_timeout_in_minutes

  tags = var.tags
}