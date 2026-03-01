I'll help you create a Terraform configuration to deploy an AWS Lightsail instance with multiple attached disks. This configuration will:

1. Create an AWS Lightsail instance running Amazon Linux 2
2. Create two additional Lightsail disks
3. Attach these disks to the Lightsail instance
4. Configure appropriate availability zone and size for the disks

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Environment = "Development"
  }
}

# Create first additional disk
resource "aws_lightsail_disk" "disk1" {
  name              = "example-disk-1"
  availability_zone = "us-east-1a"
  size_in_gb       = 32

  tags = {
    Environment = "Development"
  }
}

# Create second additional disk
resource "aws_lightsail_disk" "disk2" {
  name              = "example-disk-2"
  availability_zone = "us-east-1a"
  size_in_gb       = 64

  tags = {
    Environment = "Development"
  }
}

# Attach first disk to instance
resource "aws_lightsail_disk_attachment" "disk1_attachment" {
  disk_name     = aws_lightsail_disk.disk1.name
  instance_name = aws_lightsail_instance.example_instance.name
  disk_path     = "/dev/xvdf"
}

# Attach second disk to instance
resource "aws_lightsail_disk_attachment" "disk2_attachment" {
  disk_name     = aws_lightsail_disk.disk2.name
  instance_name = aws_lightsail_instance.example_instance.name
  disk_path     = "/dev/xvdg"
}
</iac_template>

This Terraform configuration creates:
1. An AWS Lightsail instance using Amazon Linux 2 blueprint with the nano bundle (1 vCPU, 512MB RAM)
2. Two Lightsail disks:
   - First disk: 32GB
   - Second disk: 64GB
3. Attachments for both disks to the Lightsail instance

The configuration uses the us-east-1 region and us-east-1a availability zone. All resources are tagged with "Environment = Development". The disks will be attached to the instance at /dev/xvdf and /dev/xvdg respectively.

Note that after deployment, you'll need to format and mount these disks from within the instance to make them usable. This configuration handles only the infrastructure provisioning part.