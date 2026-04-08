// Will have to settle for invividual plan files per environment for now
// We need to standardise to use TARGET_ENVIRONMENT rather than have an
// environment variable per environment and move to an assumption there will only 
// ever be one role assumption to properly decouple and clean things up
// see https://github.com/skidoosh/pipelines/tree/main/modules/codebuild 

module "pr_lint" {
  source             = "../codebuild"
  codeconnection_arn = var.codeconnection_arn
  name               = "${var.src_repo}-pr-lint"
  description        = "CodeBuild project to run ci checks for pull requests on ${var.src_repo} repo"
  build_timeout      = var.build_timeout
  queued_timeout     = var.queued_timeout
  is_ci              = true

  src_repo     = var.src_repo
  build_type   = "terraform"
  build_action = "lint"
  buildspec    = file("${path.module}/buildspecs/terraform-lint.yaml")

  environment_type                        = var.environment_type
  environment_image                       = var.environment_image
  environment_compute_type                = var.environment_compute_type
  environment_image_pull_credentials_type = var.environment_image_pull_credentials_type
  concurrent_build_limit                  = var.concurrent_build_limit

  vpc_config_security_group_ids = var.vpc_config_security_group_ids
  vpc_config_subnets            = var.vpc_config_subnets
  vpc_config_vpc_id             = var.vpc_config_vpc_id

  tags = var.tags
}

module "pr_plan" {
  for_each = toset(var.environments)

  source             = "../codebuild"
  codeconnection_arn = var.codeconnection_arn
  name               = "${var.src_repo}-pr-${each.value}"
  description        = "CodeBuild project to run ci checks for pull requests on ${var.src_repo} repo against the ${each.value} environment"
  build_timeout      = var.build_timeout
  queued_timeout     = var.queued_timeout
  is_ci              = true

  src_repo     = var.src_repo
  build_type   = "terraform"
  build_action = "plan"
  buildspec    = file("${path.module}/buildspecs/terraform-plan-${each.value}.yaml")

  environment_type                        = var.environment_type
  environment_image                       = var.environment_image
  environment_compute_type                = var.environment_compute_type
  environment_image_pull_credentials_type = var.environment_image_pull_credentials_type
  concurrent_build_limit                  = var.concurrent_build_limit

  environment_variables = [
    {
      name  = "${upper(each.value)}_TERRAFORM_PLANNER_ROLE_ARN"
      value = var.accounts[each.value].role_arns["terraform-planner"]
      type  = "PLAINTEXT"
    }
  ]

  vpc_config_security_group_ids = var.vpc_config_security_group_ids
  vpc_config_subnets            = var.vpc_config_subnets
  vpc_config_vpc_id             = var.vpc_config_vpc_id

  tags = var.tags
}
