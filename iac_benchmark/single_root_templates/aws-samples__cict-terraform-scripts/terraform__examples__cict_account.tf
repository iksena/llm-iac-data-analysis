# ── main.tf ────────────────────────────────────
locals {
  region     = var.region != "" ? var.region : data.aws_region.current.name
  account_id = var.account_id != "" ? var.account_id : data.aws_caller_identity.current.account_id
}

module "setup_testing_pipeline" {
  source                          = "../../modules/cict"
  custom_tags                     = var.custom_tags
  pipeline_deployment_bucket_name = "${var.git_repository_name}-${local.account_id}"
  account_id                      = local.account_id
  region                          = local.region
  code_pipeline_build_stages      = var.code_pipeline_build_stages
  git_repository_name             = var.git_repository_name
}

# ── variables.tf ────────────────────────────────────
variable "custom_tags" {
  description = "AWS Resource tags"
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

variable "account_id" {
  description = "Account ID where resources will be deployed"
  type        = string
  default     = ""
}

variable "git_repository_name" {
  description = "Name of the remote git repository to be created"
  type        = string
  default     = "cict-terraform"
}

variable "code_pipeline_build_stages" {
  description = "Maps of build type stages configured in CodePipeline"
  default = {
    "validate"  = "terraform/modules/buildspec-tfvalidate.yaml",
    "tflint"    = "terraform/modules/buildspec-tflint.yaml",
    "checkov"   = "terraform/modules/buildspec-checkov.yaml",
    "terratest" = "terraform/modules/buildspec-terratest.yaml"
  }
}

variable "region" {
  description = "AWS region where all the resources will be deployed"
  default     = "eu-west-2"
  type        = string
}

# ── outputs.tf ────────────────────────────────────
output "AWS_Region" {
  description = "Region  where the AWS resources will be deployed"
  value       = module.setup_testing_pipeline.region
}

output "CodePipeline_S3_bucket" {
  description = "S3 bucket storing CodePipeline artefacts"
  value       = module.setup_testing_pipeline.codepipeline_s3_bucket
}

output "CodeBuild_S3_bucket" {
  description = "S3 bucket storing CodeBuild artefacts"
  value       = module.setup_testing_pipeline.codebuild_s3_bucket
}

output "CodePipeline_Name" {
  description = "Name of the CodePipeline"
  value       = module.setup_testing_pipeline.codepipeline_name[0]
}

output "CodeCommit_Repository_Name" {
  description = "CodeCommit Repository Name"
  value       = module.setup_testing_pipeline.codecommit_repo_name
}

output "AWS_Resource_Tags" {
  description = "AWS Resource Tags to be applied"
  value       = module.setup_testing_pipeline.custom_tags
}

# ── providers.tf ────────────────────────────────────
terraform {
  required_providers {
    aws = {
      version = "~> 3.63.0"
    }
  }
}

provider "aws" {
  default_tags {
    tags = {
      Application = "test"
    }
  }
  region = var.region
}


# ── data.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}