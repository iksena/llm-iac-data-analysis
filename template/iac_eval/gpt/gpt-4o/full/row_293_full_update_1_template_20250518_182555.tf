To meet the business need, we will create two S3 buckets using Terraform. The first bucket will be used to store general data, and the second bucket will be used to store server access logs from the first bucket. We will configure the first bucket to log all access requests to the second bucket. Additionally, we will ensure that the necessary permissions are set so that the first bucket can write logs to the second bucket. The configuration will be deployed in the AWS region `us-east-1`.

Here is the Terraform HCL program that accomplishes this:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "data_bucket" {
  bucket = "my-data-bucket-123456"
  acl    = "private"

  tags = {
    Name        = "DataBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456"
  acl    = "log-delivery-write"

  tags = {
    Name        = "LogBucket"
    Environment = "Production"
  }
}

resource "aws_s3_bucket_logging" "data_bucket_logging" {
  bucket = aws_s3_bucket.data_bucket.id

  target_bucket = aws_s3_bucket.log_bucket.id
  target_prefix = "log/"
}

resource "aws_s3_bucket_policy" "log_bucket_policy" {
  bucket = aws_s3_bucket.log_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "logging.s3.amazonaws.com"
        }
        Action = "s3:PutObject"
        Resource = "${aws_s3_bucket.log_bucket.arn}/log/*"
        Condition = {
          StringEquals = {
            "aws:SourceAccount" = "${data.aws_caller_identity.current.account_id}"
          }
          ArnLike = {
            "aws:SourceArn" = "${aws_s3_bucket.data_bucket.arn}"
          }
        }
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
```
</iac_template>

This configuration sets up the necessary infrastructure to log access requests from the `data_bucket` to the `log_bucket`. The `aws_s3_bucket_logging` resource configures the logging, and the `aws_s3_bucket_policy` ensures that the logging service has the necessary permissions to write logs to the `log_bucket`.