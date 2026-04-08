terraform {
  required_version = ">=1.0.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "platsec-ci20210713082841419000000002"
    region       = "eu-west-2"
    key          = "bootstrap/v1"
    use_lockfile = true
    encrypt      = true
    kms_key_id   = "alias/s3-platsec-ci20210713082841419000000002"
  }
}
