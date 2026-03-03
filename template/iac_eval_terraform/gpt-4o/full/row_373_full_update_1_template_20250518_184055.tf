To fulfill the business need, we will set up an Amazon Lightsail instance (compute service) and a Lightsail disk (storage unit). The disk will be attached to the Lightsail instance to provide additional storage capacity. We will use the AWS provider to manage these resources in the `us-east-1` region. The configuration will include the necessary IAM roles and permissions to ensure the Lightsail instance can access the attached disk.

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

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_lightsail_disk" "example" {
  name              = "example-disk"
  availability_zone = "us-east-1a"
  size              = 20

  tags = {
    Name = "ExampleDisk"
  }
}

resource "aws_lightsail_disk_attachment" "example" {
  disk_name    = aws_lightsail_disk.example.name
  instance_name = aws_lightsail_instance.example.name
}
```

</iac_template>

This configuration sets up a Lightsail instance with a small blueprint and bundle, and a 20 GB disk. The disk is then attached to the instance, allowing it to be used as additional storage. The resources are tagged for easy identification.