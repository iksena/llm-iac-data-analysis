resource "aws_s3_directory_bucket" "this" {
  region          = var.region
  bucket          = var.bucket
  data_redundancy = var.data_redundancy
  force_destroy   = var.force_destroy
  type            = var.type
  tags            = var.tags

  location {
    name = var.location.name
    type = var.location.type
  }
}