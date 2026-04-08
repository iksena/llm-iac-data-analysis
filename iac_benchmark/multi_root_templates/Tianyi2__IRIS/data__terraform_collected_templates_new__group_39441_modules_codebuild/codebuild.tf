resource "aws_codebuild_project" "build" {
  name        = var.name
  description = var.description == "" ? "For ${var.name}" : var.description

  build_timeout          = var.build_timeout
  concurrent_build_limit = var.concurrent_build_limit
  encryption_key         = var.encryption_key
  queued_timeout         = var.queued_timeout
  service_role           = aws_iam_role.build.arn

  artifacts {
    type = var.is_ci ? "NO_ARTIFACTS" : "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = var.build_type == "container" ? ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"] : ["LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = var.environment_compute_type
    image                       = var.environment_image
    type                        = var.environment_type
    image_pull_credentials_type = var.environment_image_pull_credentials_type
    privileged_mode             = true //var.build_type == "container" ? true : false

    dynamic "environment_variable" {
      for_each = var.environment_variables

      content {
        type  = environment_variable.value.type
        name  = environment_variable.value.name
        value = environment_variable.value.value
      }
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.build.name
      stream_name = "${var.name}-${var.build_type}-${var.build_action}"
    }
  }

  source {
    type                = var.is_ci ? "GITHUB" : "CODEPIPELINE"
    buildspec           = var.buildspec
    git_clone_depth     = var.is_ci ? 1 : 0 # needed for codepipeline or all the iam policy docs get recreated 🤷
    insecure_ssl        = false
    location            = var.is_ci ? "https://github.com/${var.src_org}/${var.src_repo}" : null
    report_build_status = var.is_ci ? true : false
  }

  vpc_config {
    security_group_ids = var.vpc_config_security_group_ids
    subnets            = var.vpc_config_subnets
    vpc_id             = var.vpc_config_vpc_id
  }

  tags = merge({
    Step = var.name
  }, var.tags)
}

resource "aws_codebuild_webhook" "build" {
  count = var.is_ci ? 1 : 0

  project_name = aws_codebuild_project.build.name
  build_type   = "BUILD"

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PULL_REQUEST_CREATED, PULL_REQUEST_UPDATED, PULL_REQUEST_REOPENED"
    }
  }
}
