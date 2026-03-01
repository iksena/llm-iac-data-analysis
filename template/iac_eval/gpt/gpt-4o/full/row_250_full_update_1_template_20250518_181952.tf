To fulfill the business need, we will create an AWS Chime Voice Connector using Terraform. This will involve setting up the necessary AWS provider configuration and defining the Chime Voice Connector resource. Additionally, we will configure the Chime Voice Connector Logging resource with `enable_sip_logs` set to `false` and `enable_media_metric_logs` set to `true`. This setup will ensure that SIP logs are not collected, but media metric logs are enabled for the voice connector.

Below is the Terraform HCL configuration to achieve this:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "example" {
  name          = "example-voice-connector"
  require_encryption = false
}

resource "aws_chime_voice_connector_logging" "example_logging" {
  voice_connector_id = aws_chime_voice_connector.example.id

  enable_sip_logs          = false
  enable_media_metric_logs = true
}
```
</iac_template>

This configuration sets up an AWS Chime Voice Connector named "example-voice-connector" and configures its logging settings according to the specified requirements. The AWS provider is configured to use the "us-east-1" region.