To create a Kinesis Firehose Delivery Stream with a Splunk destination, we will define a Terraform configuration that sets up the necessary AWS resources. This includes the Kinesis Firehose Delivery Stream itself, an IAM role with the necessary permissions for the Firehose to access Splunk, and the configuration for the Splunk destination. We will use the AWS provider and specify a region for deployment. The configuration will include default values for any variables used.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "firehose_role" {
  name = "firehose_delivery_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "firehose.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "firehose_policy" {
  name        = "firehose_delivery_policy"
  description = "Policy for Kinesis Firehose to deliver data to Splunk"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "firehose_policy_attach" {
  role       = aws_iam_role.firehose_role.name
  policy_arn = aws_iam_policy.firehose_policy.arn
}

resource "aws_kinesis_firehose_delivery_stream" "splunk_stream" {
  name        = "splunk_delivery_stream"
  destination = "splunk"

  splunk_configuration {
    hec_endpoint            = "https://splunk.example.com:8088"
    hec_endpoint_type       = "Raw"
    hec_token               = "your-splunk-hec-token"
    s3_backup_mode          = "FailedEventsOnly"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/splunk"
      log_stream_name = "splunk_delivery_stream"
    }
  }

  role_arn = aws_iam_role.firehose_role.arn
}
```
</iac_template>

This configuration sets up a Kinesis Firehose Delivery Stream with a Splunk destination. It includes an IAM role with the necessary permissions for the Firehose to deliver data to Splunk and log events to CloudWatch. The Splunk configuration specifies the HEC endpoint and token, and it is set to back up failed events to S3. Adjust the `hec_endpoint` and `hec_token` with your actual Splunk endpoint and token.