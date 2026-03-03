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