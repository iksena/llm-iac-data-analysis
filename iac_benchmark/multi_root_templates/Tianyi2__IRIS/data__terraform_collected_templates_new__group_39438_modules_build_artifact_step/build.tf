resource "aws_codebuild_project" "build" {
  name          = var.step_name
  description   = "For ${var.step_name}"
  build_timeout = var.timeout_in_minutes

  service_role = aws_iam_role.build.arn

  vpc_config {
    security_group_ids = var.agent_security_group_ids
    subnets            = var.vpc_config.private_subnet_ids
    vpc_id             = var.vpc_config.vpc_id
  }

  cache {
    type  = "LOCAL"
    modes = var.docker_required ? ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"] : ["LOCAL_SOURCE_CACHE"]
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    privileged_mode             = var.docker_required
  }

  logs_config {
    cloudwatch_logs {
      group_name  = var.step_name
      stream_name = var.step_name
    }
  }

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type = "CODEPIPELINE"
  }

  tags = var.tags
}
