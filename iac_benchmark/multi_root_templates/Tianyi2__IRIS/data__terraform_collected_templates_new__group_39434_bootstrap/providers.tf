provider "aws" {
  region = "eu-west-2"

  default_tags {
    tags = {
      team        = "platsec"
      region      = "eu-west-2"
      environment = "bootstrap"
      service     = "bootstrap"
    }
  }
}