resource "aws_codepipeline" "codepipeline" {
  name     = module.common.pipeline_name
  role_arn = module.common.codepipeline_role_arn

  artifact_store {
    location = module.common.bucket_id
    type     = "S3"

    encryption_key {
      id   = module.common.kms_key_arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      namespace        = "SourceVariables"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codeconnection_arn
        FullRepositoryId = "${var.src_org}/${var.src_repo}"
        BranchName       = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = module.build_artifact_step.name
        EnvironmentVariables = jsonencode([
          {
            name  = "COMMIT_ID"
            value = "#{SourceVariables.CommitId}"
            type  = "PLAINTEXT"
          }
        ])
      }
    }

    action {
      name            = "Create_Timestamp"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      namespace       = "Timestamp"

      configuration = {
        ProjectName = module.build_timestamp_step.name
      }
    }
  }

  stage {
    name = "Upload_Image"

    action {
      name            = "Upload_To_Ecr"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ProjectName = module.upload_to_ecr.name
        EnvironmentVariables = jsonencode([
          {
            name  = "IMAGE_TAG"
            value = module.common.build_id
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  stage {
    name = "Deploy_Development"

    action {
      name            = "Deploy_Development"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ProjectName = module.docker_deployment_development.name
        EnvironmentVariables = jsonencode([
          {
            name  = "IMAGE_TAG"
            value = module.common.build_id
            type  = "PLAINTEXT"
          }
        ])
      }
    }
  }

  stage {
    name = "Approve_Production"

    action {
      name     = "Approve_Production"
      category = "Approval"
      owner    = "AWS"
      provider = "Manual"
      version  = "1"

      configuration = {
        NotificationArn : var.sns_topic_arn,
        ExternalEntityLink : "https://github.com/${var.src_org}/${var.src_repo}/commit/#{SourceVariables.CommitId}"
        CustomData : "#{SourceVariables.CommitMessage}"
      }
    }
  }

  stage {
    name = "Deploy_Production"

    action {
      name            = "Deploy_Production"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ProjectName = module.docker_deployment_production.name
        EnvironmentVariables = jsonencode([
          {
            name  = "IMAGE_TAG"
            value = module.common.build_id
            type  = "PLAINTEXT"
          }
        ])
      }

    }
  }
}
