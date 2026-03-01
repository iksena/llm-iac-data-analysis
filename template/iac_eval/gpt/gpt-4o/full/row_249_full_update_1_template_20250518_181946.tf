To meet the business need, we will create two AWS Chime Voice Connectors with encryption enabled. These connectors will then be grouped into an AWS Chime Voice Connector Group, where one connector will be given a higher priority than the other. We will use the AWS provider to manage these resources, and ensure that all necessary configurations, such as encryption settings and priorities, are correctly set.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_chime_voice_connector" "primary" {
  name       = "PrimaryVoiceConnector"
  aws_region = "us-east-1"
  encryption = true
}

resource "aws_chime_voice_connector" "secondary" {
  name       = "SecondaryVoiceConnector"
  aws_region = "us-east-1"
  encryption = true
}

resource "aws_chime_voice_connector_group" "voice_connector_group" {
  name = "VoiceConnectorGroup"

  connector {
    priority = 1
    voice_connector_id = aws_chime_voice_connector.primary.id
  }

  connector {
    priority = 2
    voice_connector_id = aws_chime_voice_connector.secondary.id
  }
}
```

</iac_template>

This configuration sets up two voice connectors with encryption enabled and groups them into a voice connector group with specified priorities. The primary connector is given a higher priority than the secondary connector.