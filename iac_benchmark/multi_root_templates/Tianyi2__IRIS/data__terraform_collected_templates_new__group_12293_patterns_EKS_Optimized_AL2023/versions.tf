terraform {
  backend "s3" {
    bucket  = "BUCKET_NAME"
    key     = "EKS_Optimized_AL2023"
    region  = "us-west-2"
    encrypt = true
  }
}