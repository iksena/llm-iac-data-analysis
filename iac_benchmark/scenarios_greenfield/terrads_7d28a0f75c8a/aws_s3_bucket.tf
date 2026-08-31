variable "aws_profile" { default = "benchmark" }
variable "bucket_name" { default = "benchmark-bucket-tf5x" }
variable "bucket_force_destroy" { default = true }

resource "aws_s3_bucket" "this" {
  bucket = var.bucket_name

  tags = {
    Name = var.aws_profile
  }

  force_destroy = var.bucket_force_destroy
  
  # lifecycle {
  #   prevent_destroy = true
  # }
}