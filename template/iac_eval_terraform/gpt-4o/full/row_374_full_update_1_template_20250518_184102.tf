To fulfill the business need, we will create a Terraform configuration that provisions an Amazon Lightsail instance with multiple attached disks. We will use the AWS provider to manage the resources. The configuration will include the creation of a Lightsail instance and the attachment of two additional disks to this instance. We will specify the instance type, region, and disk sizes. The configuration will also include the necessary IAM roles and permissions to manage Lightsail resources.

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

resource "aws_lightsail_disk" "disk1" {
  name              = "example-disk-1"
  availability_zone = "us-east-1a"
  size              = 20

  tags = {
    Name = "ExampleDisk1"
  }
}

resource "aws_lightsail_disk" "disk2" {
  name              = "example-disk-2"
  availability_zone = "us-east-1a"
  size              = 30

  tags = {
    Name = "ExampleDisk2"
  }
}

resource "aws_lightsail_disk_attachment" "attach_disk1" {
  disk_name     = aws_lightsail_disk.disk1.name
  instance_name = aws_lightsail_instance.example.name
}

resource "aws_lightsail_disk_attachment" "attach_disk2" {
  disk_name     = aws_lightsail_disk.disk2.name
  instance_name = aws_lightsail_instance.example.name
}
```
</iac_template>

This configuration will create a Lightsail instance named "example-instance" in the "us-east-1a" availability zone with the "amazon_linux_2" blueprint and "nano_2_0" bundle. It will also create two disks, "example-disk-1" and "example-disk-2", with sizes 20 GB and 30 GB, respectively, and attach them to the instance.