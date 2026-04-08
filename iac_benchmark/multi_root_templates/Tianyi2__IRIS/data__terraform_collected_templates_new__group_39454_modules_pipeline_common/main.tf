terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.src_org
}

locals {
  pipeline_name = var.pipeline
  build_id      = "#{SourceVariables.CommitId}-#{Timestamp.BUILD_TIMESTAMP}"
}
