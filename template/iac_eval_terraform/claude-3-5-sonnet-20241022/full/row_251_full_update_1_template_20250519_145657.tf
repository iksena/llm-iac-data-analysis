I'll help you create a Terraform configuration to set up an AWS Chime Voice Connector with media metrics logging enabled. Here's what the configuration will do:

1. Create an AWS Chime Voice Connector with required settings
2. Create an AWS Chime Voice Connector Logging configuration that enables only media metrics logging
3. Create necessary IAM roles and policies for logging
4. Configure CloudWatch log group for the logging

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1" # AWS Chime Voice Connector is only available in us-east-1
}

# Create the Voice Connector
resource "aws_chime_voice_connector" "connector" {
  name               = "my-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Create CloudWatch Log Group
resource "aws_cloudwatch_log_group" "voice_connector_logs" {
  name              = "/aws/chime/voiceconnector/${aws_chime_voice_connector.connector.name}"
  retention_in_days = 30
}

# Create IAM Role for Voice Connector Logging
resource "aws_iam_role" "voice_connector_logging" {
  name = "chime-voice-connector-logging-role"

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

# Create IAM Policy for Voice Connector Logging
resource "aws_iam_role_policy" "voice_connector_logging" {
  name = "chime-voice-connector-logging-policy"
  role = aws_iam_role.voice_connector_logging.id

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
        Resource = "${aws_cloudwatch_log_group.voice_connector_logs.arn}:*"
      }
    ]
  })
}

# Enable Voice Connector Logging
resource "aws_chime_voice_connector_logging" "example" {
  voice_connector_id = aws_chime_voice_connector.connector.id

  enable_media_metric_logs = true
  enable_sip_logs         = false

  depends_on = [
    aws_iam_role.voice_connector_logging,
    aws_iam_role_policy.voice_connector_logging
  ]
}
</iac_template>

This configuration creates:
1. An AWS Chime Voice Connector with encryption enabled
2. A CloudWatch Log Group to store the logs
3. An IAM role and policy that allows the Voice Connector to write logs to CloudWatch
4. A Voice Connector Logging configuration that enables only media metric logs (SIP logs are explicitly disabled)

The configuration is set in the us-east-1 region as AWS Chime Voice Connector is only available in that region. The log retention is set to 30 days by default, but you can modify this value as needed.

All resources are properly referenced and all necessary permissions are included. The Voice Connector logging configuration depends on the IAM role and policy being created first, which is ensured through the depends_on block.