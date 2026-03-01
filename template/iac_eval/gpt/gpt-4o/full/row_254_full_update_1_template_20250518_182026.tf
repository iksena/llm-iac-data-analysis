To fulfill the business need, we will create an AWS Chime Voice Connector and configure it to stream media to Amazon Kinesis. The configuration will include setting up the necessary IAM roles and policies to allow the Chime Voice Connector to stream media to Kinesis. We will use the AWS provider to manage the resources in a specified region.

The Terraform configuration will include:
1. AWS provider configuration.
2. An IAM role with a policy that allows streaming to Kinesis.
3. An AWS Chime Voice Connector.
4. Configuration for the Chime Voice Connector to stream media to an Amazon Kinesis stream.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "chime_kinesis_role" {
  name = "ChimeKinesisRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "voiceconnector.chime.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "chime_kinesis_policy" {
  name        = "ChimeKinesisPolicy"
  description = "Policy to allow Chime Voice Connector to stream to Kinesis"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "kinesis:PutRecord",
          "kinesis:PutRecords"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_chime_kinesis_policy" {
  role       = aws_iam_role.chime_kinesis_role.name
  policy_arn = aws_iam_policy.chime_kinesis_policy.arn
}

resource "aws_chime_voice_connector" "voice_connector" {
  name          = "MyChimeVoiceConnector"
  require_encryption = false
}

resource "aws_chime_voice_connector_streaming" "voice_connector_streaming" {
  voice_connector_id = aws_chime_voice_connector.voice_connector.id

  streaming_configuration {
    data_retention_in_hours = 24
    disabled                = false
    streaming_notification_targets = [
      {
        notification_target = "EventBridge"
      }
    ]
  }
}
```
</iac_template>

This configuration sets up an AWS Chime Voice Connector and configures it to stream media to Amazon Kinesis. The IAM role and policy ensure that the Chime Voice Connector has the necessary permissions to perform the streaming.