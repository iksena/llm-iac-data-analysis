provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      repository  = "${local.repo}"
      team        = "platsec"
      region      = "eu-west-2"
      environment = "bootstrap"
      service     = "ci"
    }
  }
}

# https://github.com/terraform-aws-modules/terraform-aws-vpc/issues/625
provider "aws" {
  alias  = "no-default-tags"
  region = "eu-west-2"
}

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"

  default_tags {
    tags = {
      repository  = "${local.repo}"
      team        = "platsec"
      region      = "us-east-1"
      environment = "bootstrap"
      service     = "ci"
    }
  }
}