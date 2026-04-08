resource "aws_amplify_app" "this" {
  name                          = var.name
  access_token                  = var.access_token
  auto_branch_creation_patterns = var.auto_branch_creation_patterns
  basic_auth_credentials        = var.basic_auth_credentials
  build_spec                    = var.build_spec
  compute_role_arn              = var.compute_role_arn
  custom_headers                = var.custom_headers
  description                   = var.description
  enable_auto_branch_creation   = var.enable_auto_branch_creation
  enable_basic_auth             = var.enable_basic_auth
  enable_branch_auto_build      = var.enable_branch_auto_build
  enable_branch_auto_deletion   = var.enable_branch_auto_deletion
  environment_variables         = var.environment_variables
  iam_service_role_arn          = var.iam_service_role_arn
  oauth_token                   = var.oauth_token
  platform                      = var.platform
  repository                    = var.repository
  tags                          = var.tags

  dynamic "auto_branch_creation_config" {
    for_each = var.auto_branch_creation_config != null ? [var.auto_branch_creation_config] : []
    content {
      basic_auth_credentials        = auto_branch_creation_config.value.basic_auth_credentials
      build_spec                    = auto_branch_creation_config.value.build_spec
      enable_auto_build             = auto_branch_creation_config.value.enable_auto_build
      enable_basic_auth             = auto_branch_creation_config.value.enable_basic_auth
      enable_performance_mode       = auto_branch_creation_config.value.enable_performance_mode
      enable_pull_request_preview   = auto_branch_creation_config.value.enable_pull_request_preview
      environment_variables         = auto_branch_creation_config.value.environment_variables
      framework                     = auto_branch_creation_config.value.framework
      pull_request_environment_name = auto_branch_creation_config.value.pull_request_environment_name
      stage                         = auto_branch_creation_config.value.stage
    }
  }

  dynamic "cache_config" {
    for_each = var.cache_config != null ? [var.cache_config] : []
    content {
      type = cache_config.value.type
    }
  }

  dynamic "custom_rule" {
    for_each = var.custom_rule
    content {
      condition = custom_rule.value.condition
      source    = custom_rule.value.source
      status    = custom_rule.value.status
      target    = custom_rule.value.target
    }
  }

  dynamic "job_config" {
    for_each = var.job_config != null ? [var.job_config] : []
    content {
      build_compute_type = job_config.value.build_compute_type
    }
  }
}