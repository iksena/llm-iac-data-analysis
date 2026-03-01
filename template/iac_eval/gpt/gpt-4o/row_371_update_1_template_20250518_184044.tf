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