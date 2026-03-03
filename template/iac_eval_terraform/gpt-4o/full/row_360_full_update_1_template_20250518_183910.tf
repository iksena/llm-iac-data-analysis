To fulfill the business need, we will create an AWS Lightsail instance with automatic snapshots enabled. AWS Lightsail is a simplified cloud platform that provides everything needed to build an application or website, plus a cost-effective, monthly plan. We will configure the Lightsail instance with a basic plan and enable automatic snapshots to ensure data backup and recovery. The Terraform configuration will include the necessary provider configuration, the Lightsail instance resource, and the automatic snapshot settings.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-west-2a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_lightsail_instance_snapshot" "example_snapshot" {
  name               = "example-snapshot"
  instance_name      = aws_lightsail_instance.example.name
  create_at          = "2023-10-01T00:00:00Z" # Example date, adjust as needed
  auto_snapshot_add  = true
}

resource "aws_lightsail_instance_auto_snapshot" "example_auto_snapshot" {
  instance_name = aws_lightsail_instance.example.name
  enabled       = true
}
```
</iac_template>

This configuration sets up a Lightsail instance in the `us-west-2` region with a basic `nano_2_0` plan. It also configures automatic snapshots to ensure that the instance's data is backed up regularly. Adjust the `create_at` date for the snapshot as needed to fit your schedule.