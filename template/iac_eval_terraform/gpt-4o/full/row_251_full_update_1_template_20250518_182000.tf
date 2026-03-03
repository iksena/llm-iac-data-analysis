To fulfill the business need, we will create an AWS Chime Voice Connector and configure it to log media metrics using the AWS Chime Voice Connector Logging resource. The Terraform configuration will include the necessary IAM roles and policies to allow logging. We will use the AWS provider and specify a region where AWS Chime services are available.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "example" {
  name          = "ExampleVoiceConnector"
  require_encryption = true
}

resource "aws_chime_voice_connector_logging" "example_logging" {
  voice_connector_id = aws_chime_voice_connector.example.id

  media_metrics {
    enabled = true
  }
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
  description = "Policy to allow Chime Voice Connector logging"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "chime_logging_policy_attachment" {
  role       = aws_iam_role.chime_logging_role.name
  policy_arn = aws_iam_policy.chime_logging_policy.arn
}
```
</iac_template>

This configuration sets up an AWS Chime Voice Connector and enables logging for media metrics. It also creates an IAM role and policy to allow the Chime service to log media metrics to CloudWatch Logs. The configuration uses the `us-east-1` region, which supports AWS Chime services.