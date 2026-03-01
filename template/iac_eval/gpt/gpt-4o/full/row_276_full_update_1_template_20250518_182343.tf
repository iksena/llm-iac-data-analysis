The Terraform program will create an AWS S3 bucket and an SNS topic. It will configure the S3 bucket to send a notification to the SNS topic whenever a new object with a `.log` extension is created in the bucket. The program will include the necessary resources to set up the S3 bucket and SNS topic, but it will not include the IAM policies required for permissions, as per the instruction.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "log_bucket" {
  bucket = "my-log-bucket-123456789"
  acl    = "private"

  versioning {
    enabled = true
  }

  tags = {
    Name        = "LogBucket"
    Environment = "Dev"
  }
}

resource "aws_sns_topic" "log_topic" {
  name = "log-notification-topic"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.log_bucket.id

  topic {
    topic_arn = aws_sns_topic.log_topic.arn
    events    = ["s3:ObjectCreated:*"]

    filter_suffix = ".log"
  }
}
```

</iac_template>

This configuration sets up an S3 bucket with versioning enabled and a private ACL. It also creates an SNS topic and configures the S3 bucket to send notifications to the SNS topic whenever a `.log` file is created. The bucket name is globally unique, so you may need to change it to a unique name for your AWS account.