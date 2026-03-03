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