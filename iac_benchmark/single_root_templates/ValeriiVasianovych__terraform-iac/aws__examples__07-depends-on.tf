# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket         = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt        = true
    key            = "aws/tfstates/depends-on/terraform.tfstate"
    region         = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

# ── outputs.tf ────────────────────────────────────
output "aws_region" {
  value = data.aws_region.current.name
} 

output "aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_region_id" {
  value = data.aws_region.current.id
}

# ── datasorce.tf ────────────────────────────────────
data "aws_region" "current" {}

# ── s3-depends-on.tf ────────────────────────────────────
resource "aws_s3_bucket" "bucket-1" {
  bucket = "my-tf-bucket-1-s3"
  }

resource "aws_s3_bucket" "bucket-2" {
  bucket = "my-tf-bucket-2-s3"
  depends_on = [ aws_s3_bucket.bucket-1 ]
}

resource "aws_s3_bucket" "bucket-3" {
  bucket = "my-tf-bucket-3-s3"
  depends_on = [ aws_s3_bucket.bucket-1, aws_s3_bucket.bucket-2 ]
}