data "aws_s3_directory_buckets" "this" {
  region = var.region
}