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

# Create Lightsail Disk
resource "aws_lightsail_disk" "example_disk" {
  name              = "example-disk"
  availability_zone = "us-east-1a"
  size_in_gb        = 8

  tags = {
    Environment = "Development"
  }
}

# Attach Disk to Instance
resource "aws_lightsail_disk_attachment" "example_disk_attachment" {
  disk_name     = aws_lightsail_disk.example_disk.name
  instance_name = aws_lightsail_instance.example_instance.name
  disk_path     = "/dev/xvdf"
}

# Output the instance public IP address
output "instance_ip" {
  value = aws_lightsail_instance.example_instance.public_ip_address
}

# Output the disk name
output "disk_name" {
  value = aws_lightsail_disk.example_disk.name
}