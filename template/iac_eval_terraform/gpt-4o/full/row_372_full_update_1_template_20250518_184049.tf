To fulfill the business need, we will create a Terraform configuration that provisions a Lightsail Disk and attaches it to an existing Lightsail Instance. We will use the AWS provider to manage the resources in the AWS Lightsail service. The configuration will include the creation of a Lightsail Disk with a specified size and the attachment of this disk to a pre-existing Lightsail Instance. We will assume that the Lightsail Instance already exists and will be referenced by its name.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_disk" "example_disk" {
  name       = "example-disk"
  size       = 20 # Size in GB
  availability_zone = "us-east-1a"
}

resource "aws_lightsail_disk_attachment" "example_attachment" {
  disk_name     = aws_lightsail_disk.example_disk.name
  instance_name = "example-instance" # Replace with your existing instance name
}

```

</iac_template>

This configuration will create a 20 GB Lightsail Disk in the `us-east-1a` availability zone and attach it to an existing Lightsail Instance named `example-instance`. Make sure to replace `"example-instance"` with the actual name of your Lightsail Instance.