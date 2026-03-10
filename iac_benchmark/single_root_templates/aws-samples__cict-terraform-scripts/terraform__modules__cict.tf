# ── variables.tf ────────────────────────────────────
variable "custom_tags" {
  description = "Resources tags"
  type = object({
    Environment    = string
    DeploymentType = string
    Application    = string
  })
  default = {
    Environment    = "Deployment"
    DeploymentType = "Terraform"
    Application    = "testapp"
  }
}

variable "git_repository_name" {
  description = "Name of the remote git repository to be created"
  default = "codecommit-default"
  type        = string
}

variable "code_pipeline_build_stages" {
  description = "maps of build type stages configured in CodePipeline"
  default = {
    "validate" = "terraform/modules/buildspec-tfvalidate.yaml",
    "tflint" = "terraform/modules/buildspec-tflint.yaml",
    "checkov" = "terraform/modules/buildspec-checkov.yaml",
    "terratest" = "terraform/modules/buildspec-terratest.yaml"
  }
}

variable "region" {
  description = "AWS region where the resources will be deployed"
  default     = "eu-west-2"
  type        = string
}

variable "account_id" {
  description = "Account ID where resources will be deployed"
  type        = string
  default     = ""
}

variable "priv_vpc_config" {
  description = "Map of values for private VPC, subnet_ids and security_group_ids are comma separated lists"
  type = object({
    vpc_id             = string
    subnet_ids         = string
    security_group_ids = string
  })
  default = {
    vpc_id             = ""
    subnet_ids         = ""
    security_group_ids = ""
  }
}

variable "roles" {
  description = "Roles ARN used to deploy, in case of cross account deployments these roles should thrust the CIDE account"
  type        = list(any)
  default     = []
}

variable "proxy_config" {
  description = "Proxies used by CodeBuild"
  type = object({
    HTTP_PROXY  = string
    HTTPS_PROXY = string
    NO_PROXY    = string
    no_proxy    = string
    https_proxy = string
    http_proxy  = string
  })
  default = {
    HTTP_PROXY  = ""
    HTTPS_PROXY = ""
    no_proxy    = ""
    https_proxy = ""
    http_proxy  = ""
    NO_PROXY    = ""
  }
}


variable "branches" {
  description = "Branches to be built"
  type        = list(string)
  default     = ["cleanup"]
}


variable "pipeline_deployment_bucket_name" {
  description = "Bucket used by codepipeline and codebuild to store artifacts regarding the deployment"
  type        = string
  default     = "testrandom"
}

variable "codebuild_image" {
  description = "Describe the AWS CodeBuild Image"
  type = string
  default = "aws/codebuild/standard:5.0"
}

# ── outputs.tf ────────────────────────────────────
output "codepipeline_name" {
  value = values(aws_codepipeline.awscodepipeline)[*].id
}

output "codebuild_name" {
  value = values(aws_codebuild_project.awscodebuild_project)[*].name
}

output "codepipeline_s3_bucket" {
  value = aws_s3_bucket.awscodepipeline_s3_bucket.bucket
}

output "codebuild_s3_bucket" {
  value = aws_s3_bucket.awscodebuild_bucket.bucket
}

output "codecommit_repo_name" {
  value = aws_codecommit_repository.awscodecommit_repo.repository_name
}

output "custom_tags" {
  value = aws_codecommit_repository.awscodecommit_repo.tags
}

output "region" {
  value = data.aws_region.current.name
}

# ── providers.tf ────────────────────────────────────
provider "aws" {
  region = var.region
}

# ── locals.tf ────────────────────────────────────
locals {
  buckets_to_lock = {
    codepipeline = aws_s3_bucket.awscodepipeline_s3_bucket.id
    codebuild    = aws_s3_bucket.awscodebuild_bucket.id
  }
}

# ── codebuild.tf ────────────────────────────────────
#### Create a CODEBUILD Project #####

resource "random_pet" "rname" {
}

resource "aws_codebuild_project" "awscodebuild_project" {
  for_each      = var.code_pipeline_build_stages
  name          = "${random_pet.rname.id}-${each.key}-cb-project"
  description   = "Code build project for ${var.git_repository_name} ${each.key} stage"
  build_timeout = "120"
  service_role  = aws_iam_role.awscodebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  cache {
    type  = "LOCAL"
    modes = ["LOCAL_DOCKER_LAYER_CACHE"]
  }

  environment {
    image                       = var.codebuild_image
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
    compute_type                = "BUILD_GENERAL1_SMALL"

    dynamic "environment_variable" {
      for_each = var.proxy_config["HTTP_PROXY"] != "" ? var.proxy_config : {}
      content {
        name  = environment_variable.key
        value = environment_variable.value
      }
    }
  }

 
  dynamic "vpc_config" {
    for_each = var.priv_vpc_config["vpc_id"] != "" ? [var.priv_vpc_config["vpc_id"]] : []
    content {
      vpc_id             = var.priv_vpc_config["vpc_id"]
      subnets            = split(",", var.priv_vpc_config["subnet_ids"])
      security_group_ids = split(",", var.priv_vpc_config["security_group_ids"])
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.awscodebuild_bucket.id}/${each.key}/build_logs"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = each.value
  }

  tags = var.custom_tags

}

# ── codecommit.tf ────────────────────────────────────
#### Create CODECOMMIT REPOSITORY ####

resource "aws_codecommit_repository" "awscodecommit_repo" {
  repository_name = var.git_repository_name
  description     = "Code Repository For CICT CODEPIPELINE PROJECT"

  tags = var.custom_tags
}

# ── codepipeline.tf ────────────────────────────────────
#### Create CodePipeline with multiple stages and CodeBuild actions ####

resource "aws_codepipeline" "awscodepipeline" {
  for_each = toset(var.branches)
  name     = "${var.git_repository_name}-${each.value}"
  role_arn = aws_iam_role.awscodepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.awscodepipeline_s3_bucket.bucket
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source-${var.git_repository_name}"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeCommit"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        RepositoryName = var.git_repository_name
        BranchName     = each.value
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "TF-Lint"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["tflint_output"]
      version          = "1"
      run_order        = 1

      configuration = {
        ProjectName = aws_codebuild_project.awscodebuild_project["tflint"].name
        EnvironmentVariables = jsonencode([{
          name  = "ENVIRONMENT"
          value = each.value
          }])
      }
    }

    action {
      name             = "TF-Validate"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["validate_output"]
      version          = "1"
      run_order        = 1

      configuration = {
        ProjectName = aws_codebuild_project.awscodebuild_project["validate"].name
        EnvironmentVariables = jsonencode([{
          name  = "ENVIRONMENT"
          value = each.value
          }])
      }
    }

    action {
      name             = "TF-Terratest"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["terratest_output"]
      version          = "1"
      run_order        = 1

      configuration = {
        ProjectName = aws_codebuild_project.awscodebuild_project["terratest"].name
        EnvironmentVariables = jsonencode([{
          name  = "ENVIRONMENT"
          value = each.value
          }])
      }
    }

    action {
      name             = "TF-Checkov"
      category         = "Test"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["validate_output"]
      output_artifacts = ["checkov_output"]
      version          = "1"
      run_order        = 2

      configuration = {
        ProjectName = aws_codebuild_project.awscodebuild_project["checkov"].name
        EnvironmentVariables = jsonencode([{
          name  = "ENVIRONMENT"
          value = each.value
          }])
      }
    }
  }
  tags = var.custom_tags
}

# ── data.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# ── iam.tf ────────────────────────────────────
#### Create IAM Cross-account Role and Policy for Codebuild projects ####

resource "aws_iam_role" "awscodebuild_role" {
  name = "codebuild-${var.git_repository_name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "awscodebuild_policy" {
  name = "codebuild-${var.git_repository_name}-policy"
  role = aws_iam_role.awscodebuild_role.name

  policy = templatefile("${path.module}/templates/codebuild-role_policy.json.tpl",
    {
      codepipeline_artifact_bucket = aws_s3_bucket.awscodepipeline_s3_bucket.arn
      priv_vpc_id                  = var.priv_vpc_config["vpc_id"]
      account_id                   = data.aws_caller_identity.current.account_id
  })
}

#### Create IAM role and policies for CodePipeline ####

resource "aws_iam_role" "awscodepipeline_role" {
  name = "codepipeline-${random_pet.rname.id}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "awscodepipeline_policy" {
  name = "codepipeline-${random_pet.rname.id}-policy"
  role = aws_iam_role.awscodepipeline_role.id

  policy = templatefile("${path.module}/templates/codepipeline-role-policy.json.tpl", {
    codepipeline_bucket_arn = aws_s3_bucket.awscodepipeline_s3_bucket.arn
  })
}

# ── s3.tf ────────────────────────────────────
#### Create Amazon S3 Codepipeline artefacts bucket ####

resource "aws_s3_bucket" "awscodepipeline_s3_bucket" {
  bucket = "${var.pipeline_deployment_bucket_name}-${data.aws_region.current.name}-codepipeline"
  acl    = "private"
  #checkov:skip=CKV2_AWS_6
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  # Neede for CloudWatch
  versioning {
    enabled = true
  }

  tags = var.custom_tags
}


#### Create Amazon S3 bucket for Codebuild project ####

resource "aws_s3_bucket" "awscodebuild_bucket" {
  bucket = "${var.pipeline_deployment_bucket_name}-${data.aws_region.current.name}-codebuild"
  acl    = "private"
  #checkov:skip=CKV2_AWS_6
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  tags = var.custom_tags
}

resource "aws_s3_bucket_public_access_block" "pipeline_buckets" {

  for_each                = local.buckets_to_lock
  bucket                  = each.value
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}