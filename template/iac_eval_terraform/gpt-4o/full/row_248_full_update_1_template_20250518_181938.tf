To fulfill the business need, we will create two AWS Chime Voice Connectors with encryption enabled. These connectors will then be grouped into an AWS Chime Voice Connector Group. The first connector will be assigned a priority of 1, and the second connector will have a priority of 3. We will use the AWS provider to manage these resources, and the configuration will be set in the `us-east-1` region. IAM roles and policies will be created as needed to allow the necessary permissions for managing Chime resources.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "connector1" {
  name       = "VoiceConnector1"
  require_encryption = true
}

resource "aws_chime_voice_connector" "connector2" {
  name       = "VoiceConnector2"
  require_encryption = true
}

resource "aws_chime_voice_connector_group" "voice_connector_group" {
  name = "VoiceConnectorGroup"

  connector {
    priority = 1
    voice_connector_id = aws_chime_voice_connector.connector1.id
  }

  connector {
    priority = 3
    voice_connector_id = aws_chime_voice_connector.connector2.id
  }
}
```
</iac_template>

This configuration will create two encrypted AWS Chime Voice Connectors and group them into a Voice Connector Group with specified priorities.