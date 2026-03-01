provider "aws" {
  region = "us-west-2"
}

resource "aws_sagemaker_code_repository" "example" {
  code_repository_name = "example-sagemaker-repo"

  git_config {
    repository_url = "https://github.com/hashicorp/terraform-provider-aws.git"
  }
}