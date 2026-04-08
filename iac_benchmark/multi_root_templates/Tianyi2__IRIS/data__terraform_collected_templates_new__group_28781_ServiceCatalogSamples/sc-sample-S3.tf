# Terraform template to create an S3 Bucket 

variable "bucket_name" {
  type = string
}
variable "aws_region" {
  type = string
}
provider "aws" {
  region = var.aws_region
}

resource "random_id" "ran_dom_suffix" {
  byte_length = 8
}

locals {
	bucketname = "${var.bucket_name}${random_id.ran_dom_suffix.hex}"
}    
	
resource "aws_s3_bucket" "bucket" {
  bucket = local.bucketname
}

output webaddress {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}
