# Import existing S3 bucket from AWS
resource "aws_s3_bucket" "import-example" {
  bucket = "rds-import-s3-bucket" # actual bucket name in AWS
}

# terraform import aws_s3_bucket.import-example minikube-crossplane-bucket-v2