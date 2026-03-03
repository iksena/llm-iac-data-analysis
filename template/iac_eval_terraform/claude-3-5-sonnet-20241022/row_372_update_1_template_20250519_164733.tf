provider "aws" {
  region = "us-east-1"
}

# Create a Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Environment = "Development"
  }
}

# Create a Lightsail Disk
resource "aws_lightsail_disk" "example_disk" {
  name              = "example-disk"
  size_in_gb        = 8
  availability_zone = "us-east-1a"

  tags = {
    Environment = "Development"
  }
}

# Attach the disk to the instance
resource "aws_lightsail_disk_attachment" "example_attachment" {
  disk_name     = aws_lightsail_disk.example_disk.name
  instance_name = aws_lightsail_instance.example_instance.name
  disk_path     = "/dev/xvdf"
}