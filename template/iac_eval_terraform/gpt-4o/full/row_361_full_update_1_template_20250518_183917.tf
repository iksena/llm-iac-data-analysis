To fulfill the business need, we will create an AWS Lightsail instance using Terraform. AWS Lightsail is a simplified cloud platform that provides everything needed to build an application or website, including virtual servers, storage, and networking. In this configuration, we will set up a Lightsail instance with a default blueprint, which is a pre-configured operating system or application stack. We will use the AWS provider to manage the resources and specify a region where the Lightsail instance will be deployed. Additionally, we will define the instance plan and blueprint ID to ensure the instance is created with the desired specifications.

<iac_template>
```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-lightsail-instance"
  availability_zone = "us-west-2a"
  blueprint_id      = "amazon_linux_2" # Default blueprint for Amazon Linux 2
  bundle_id         = "nano_2_0"       # Smallest instance plan

  tags = {
    Name = "ExampleLightsailInstance"
  }
}
```
</iac_template>

This Terraform configuration will create a Lightsail instance in the `us-west-2` region using the `amazon_linux_2` blueprint and the `nano_2_0` bundle, which is the smallest available plan. The instance will be tagged with the name "ExampleLightsailInstance" for easy identification.