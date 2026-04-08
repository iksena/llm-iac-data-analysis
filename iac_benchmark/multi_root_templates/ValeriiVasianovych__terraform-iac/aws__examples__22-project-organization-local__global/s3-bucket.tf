terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/local-modules-s3/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "bucket" {
  bucket = "terraform-aws-s3-bucket-example-${var.region}"

  tags = merge(
    var.common_tags,
    {
      Type : "S3 Bucket"
    }
  )
}