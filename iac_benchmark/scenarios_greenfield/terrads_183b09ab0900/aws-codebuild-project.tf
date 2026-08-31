# code build
resource "aws_codebuild_project" "demo" {
  name           = local.codebuild-project-name
  description    = "code build for ${local.app-name} branch ${local.branch-name}"
  build_timeout  = local.build-timeout
  service_role = data.aws_iam_role.code-build.arn
  encryption_key = data.aws_kms_key.pipelinekey.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  #cache {
  #  type     = "S3"
  #  location = aws_s3_bucket.codebuild-cache.bucket
  #}

  environment {
    compute_type    = local.compute_type
    image           = local.image
    type            = local.type
    privileged_mode = local.privileged_mode

    environment_variable {
      name  = "AWS_DEFAULT_REGION"
      value = local.region
    }
    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }
    environment_variable {
      name  = "IMAGE_REPO_URL"
      value=data.aws_ecr_repository.ecr-repo.repository_url
    }

    environment_variable {
      name  = "APP_NAME"
      value=local.app-name
    }

    environment_variable {
      name  = "BRANCH_NAME"
      value=local.branch-name
    }

  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  #depends_on      = [aws_s3_bucket.codebuild-cache]
}
