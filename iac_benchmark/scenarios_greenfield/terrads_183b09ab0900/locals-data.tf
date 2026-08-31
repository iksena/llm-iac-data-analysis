locals {
  app-name               = "springk8s"
  branch-name            = "master"
  region                 = "eu-central-1"
  s3-bucket              = local.app-name
  pipeline-name          = "ci-${local.app-name}-${local.branch-name}"
  codebuild-project-name = "cbld-${local.app-name}-${local.branch-name}"
  codebuild-cache-s3     = "codebuild-cache-${local.s3-bucket}-${random_string.s3-randomness.result}"
  demo-artifacts-s3      = "artifacts-${local.s3-bucket}-${random_string.s3-randomness.result}"
  # build projects
  build-timeout   = 60 # default is 60 , min 5 minutes ,max 480 minutes (8 hours)
  compute_type    = "BUILD_GENERAL1_SMALL"
  image           = "aws/codebuild/standard:3.0"
  #image           = "aws/codebuild/standard:5.0"
  type            = "LINUX_CONTAINER"
  privileged_mode = true


  #
  #  pipeline-stages = [
  #    {
  #      name = "Source"
  #      action = {
  #        name     = "Source"
  #        category = "Source"
  #        owner    = "AWS"
  #        provider = "CodeCommit"
  #      }
  #    },
  #    {
  #      name = "Build"
  #      action = {
  #        name             = "Build"
  #        category         = "Build"
  #        owner            = "AWS"
  #        provider         = "CodeBuild"
  #        input_artifacts  = ["demo-docker-source"]
  #        output_artifacts = ["demo-docker-build"]
  #        version          = "1"
  #      }
  #    }
  #  ]
}

data "aws_caller_identity" "current" {}

data "aws_codecommit_repository" "coderepo" {
  repository_name = "springk8s"
}

data "aws_iam_role" "code-pipeline" {
  name = "rol-glob-mgmt-tnet-cicdpipeline-001"
}

data "aws_iam_role" "code-build" {
  name = "rol-glob-mgmt-tnet-cicdcodebuild-001"
}

data "aws_kms_key" "pipelinekey" {
  key_id = "alias/kms-euc1-mgmt-tnet-cicd-001"
}

data "aws_ecr_repository" "ecr-repo" {
  name = "poc"
}

data "aws_s3_bucket" "artifact" {
  bucket = "s3-euc1-mgmt-tnet-cicdartifact-001"
}


#
#

#data "aws_kms_key" "n-core-kms" {
#  key_id = "arn:aws:kms:eu-central-1:373612170290:key/593d6491-add5-4c62-a6ed-ddbd715dcb61"
#}


resource "random_string" "s3-randomness" {
  length  = 8
  special = false
  upper   = false
}
