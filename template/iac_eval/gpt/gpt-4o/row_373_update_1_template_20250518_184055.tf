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