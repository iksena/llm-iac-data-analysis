locals {
  step_assume_roles = merge(var.step_assume_roles...)
}

module "apply_step" {
  for_each = local.step_assume_roles
  source   = "../terraform_step"

  docker_required    = true
  step_name          = "${module.common.pipeline_name}-apply-${each.key}"
  timeout_in_minutes = var.test_timeout_in_minutes

  s3_bucket_arn       = module.common.bucket_arn
  policy_arns         = [module.common.policy_build_core_arn, aws_iam_policy.secretsmanager.arn]
  step_assume_roles   = each.value
  build_spec_contents = templatefile("${path.module}/buildspecs/apply.yaml.tpl", { target = each.key })

  environment_compute_type = "BUILD_GENERAL1_MEDIUM"
  environment_type         = "LINUX_CONTAINER"

  vpc_config               = var.vpc_config
  agent_security_group_ids = values(var.agent_security_group_ids)

  tags = var.tags
}

module "build_timestamp_step" {
  source      = "../build_timestamp_step"
  step_name   = "${module.common.pipeline_name}-timestamp"
  policy_arns = [module.common.policy_build_core_arn]

  tags = var.tags
}
