To create a Lightsail Disk resource using Terraform, we will define a configuration that sets up an AWS Lightsail disk. This disk can be attached to a Lightsail instance for additional storage. We will specify the disk size and availability zone. The configuration will include the AWS provider setup, and we will ensure that all necessary parameters are defined for the Lightsail disk.

Here is the Terraform HCL configuration for creating a Lightsail Disk:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_disk" "example" {
  name              = "example-disk"
  availability_zone = "us-east-1a"
  size              = 20  # Size in GB
}

output "disk_id" {
  value = aws_lightsail_disk.example.id
}
```
</iac_template>

This configuration will create a Lightsail disk named "example-disk" with a size of 20 GB in the "us-east-1a" availability zone. The `disk_id` output will provide the ID of the created disk.