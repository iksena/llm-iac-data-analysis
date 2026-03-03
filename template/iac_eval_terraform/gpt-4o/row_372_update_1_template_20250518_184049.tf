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