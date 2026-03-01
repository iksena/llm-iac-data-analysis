To create an AWS Chime Voice Connector with encryption and log media metrics, we will define a Terraform configuration that sets up the necessary AWS resources. This includes creating a Chime Voice Connector with encryption enabled and configuring it to log media metrics to CloudWatch. We will also set up the necessary IAM roles and policies to allow Chime to log metrics.

The Terraform configuration will include:
1. AWS provider configuration.
2. An IAM role and policy for logging media metrics.
3. A Chime Voice Connector with encryption enabled.
4. Configuration to log media metrics to CloudWatch.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "chime_logging_role" {
  name = "ChimeLoggingRole"

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

resource "aws_iam_policy" "chime_logging_policy" {
  name        = "ChimeLoggingPolicy"
  description = "Policy to allow Chime to log media metrics to CloudWatch"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_chime_logging_policy" {
  role       = aws_iam_role.chime_logging_role.name
  policy_arn = aws_iam_policy.chime_logging_policy.arn
}

resource "aws_chime_voice_connector" "voice_connector" {
  name        = "MyVoiceConnector"
  require_encryption = true
}

resource "aws_chime_voice_connector_logging" "voice_connector_logging" {
  voice_connector_id = aws_chime_voice_connector.voice_connector.id

  media_metric_logs {
    enabled = true
  }
}
```
</iac_template>

This configuration sets up a Chime Voice Connector with encryption enabled and configures it to log media metrics to CloudWatch. The IAM role and policy allow the Chime service to create and write logs to CloudWatch.