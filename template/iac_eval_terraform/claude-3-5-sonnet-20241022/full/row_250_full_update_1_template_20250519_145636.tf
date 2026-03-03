I'll help you create a Terraform configuration to set up an AWS Chime Voice Connector with logging configuration. Here's what we'll create:

1. An AWS Chime Voice Connector with basic configuration
2. A Voice Connector Logging resource with SIP logs disabled and media metric logs enabled

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1" # Voice Connector is only supported in us-east-1 and us-west-2
}

# Create the AWS Chime Voice Connector
resource "aws_chimesd_voice_connector" "example" {
  name               = "example-voice-connector"
  aws_region         = "us-east-1"
  require_encryption = true
}

# Create the Voice Connector Logging configuration
resource "aws_chimesd_voice_connector_logging" "example" {
  voice_connector_id         = aws_chimesd_voice_connector.example.id
  enable_sip_logs           = false
  enable_media_metric_logs  = true
}
</iac_template>

This Terraform configuration does the following:

1. Sets up the AWS provider in the us-east-1 region (AWS Chime Voice Connector is only available in us-east-1 and us-west-2)
2. Creates an AWS Chime Voice Connector with:
   - A name "example-voice-connector"
   - Region set to us-east-1
   - Encryption required for security
3. Creates a Voice Connector Logging configuration that:
   - Links to the created Voice Connector using its ID
   - Disables SIP logs as requested
   - Enables media metric logs as requested

The configuration is complete and deployable. Note that AWS Chime Voice Connector requires appropriate IAM permissions to be set up, but these are typically handled through the AWS account's default service roles.