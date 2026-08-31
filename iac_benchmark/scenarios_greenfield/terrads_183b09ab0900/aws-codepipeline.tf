resource "aws_codepipeline" "demo" {
  name     = local.pipeline-name
  role_arn = data.aws_iam_role.code-pipeline.arn

  # we will store artifact in s3, we are encrypting it with KMS key
  artifact_store {
    #location = "s3-euc1-mgmt-tnet-cicdartifact-bcv-001"
    location = data.aws_s3_bucket.artifact.bucket
    type     = "S3"
    encryption_key {
      id   = data.aws_kms_key.pipelinekey.arn
      type = "KMS"
    }
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["demo-docker-source"]

      configuration = {
        RepositoryName = data.aws_codecommit_repository.coderepo.repository_name
        BranchName     = "master"
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
      input_artifacts  = ["demo-docker-source"]
      output_artifacts = ["demo-docker-build"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.demo.name
      }
    }
  }
}
