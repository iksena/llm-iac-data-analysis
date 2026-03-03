To create a basic Kinesis Video Stream resource using Terraform, we will define a configuration that sets up an AWS Kinesis Video Stream. This will include specifying the stream name and any necessary configurations. We will also configure the AWS provider to ensure the resources are created in a specified region. IAM roles or policies are not required for basic stream creation, but the AWS provider will need appropriate permissions to create the stream.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_kinesis_video_stream" "example" {
  name = "example-video-stream"

  data_retention_in_hours = 24

  tags = {
    Environment = "dev"
    Project     = "VideoStreamProject"
  }
}
```
</iac_template>

This Terraform configuration sets up a Kinesis Video Stream named "example-video-stream" in the "us-west-2" region with a data retention period of 24 hours. Tags are added for organizational purposes. The AWS provider is configured to use the "us-west-2" region.