The Terraform program will create two S3 buckets in AWS. The first bucket will be used to store general data, while the second bucket will be designated for storing logs. The logging configuration will be set up on the first bucket to send access logs to the second bucket. The log object keys will have a prefix of "log/" to organize the logs within the second bucket.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-bucket-123456"
  acl    = "private"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456"
  acl    = "private"
}

resource "aws_s3_bucket_logging" "data_bucket_logging" {
  bucket = aws_s3_bucket.data_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}
```
</iac_template>

This configuration includes two S3 buckets: `my-data-bucket-123456` for general data and `my-log-bucket-123456` for storing logs. The logging configuration is applied to the `my-data-bucket-123456` bucket, directing logs to the `my-log-bucket-123456` with a prefix of "log/". Make sure to replace the bucket names with globally unique names before deployment.