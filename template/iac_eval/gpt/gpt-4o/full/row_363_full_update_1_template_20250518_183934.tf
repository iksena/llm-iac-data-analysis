To fulfill the business need, we will create an Amazon Lightsail instance and attach a static IPv4 address to it. Amazon Lightsail is a simplified cloud platform that provides everything needed to build an application or website, plus a cost-effective, monthly plan. The Terraform configuration will include the necessary provider configuration for AWS, the creation of a Lightsail instance, and the allocation and attachment of a static IP address to the instance.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
}

resource "aws_lightsail_static_ip" "example_ip" {
  name = "example-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "example_ip_attachment" {
  static_ip_name   = aws_lightsail_static_ip.example_ip.name
  instance_name    = aws_lightsail_instance.example.name
}
```
</iac_template>

This configuration does the following:
- Sets up the AWS provider to use the `us-east-1` region.
- Creates a Lightsail instance named `example-instance` in the `us-east-1a` availability zone using the `amazon_linux_2` blueprint and `nano_2_0` bundle.
- Allocates a static IP address named `example-static-ip`.
- Attaches the static IP address to the Lightsail instance.