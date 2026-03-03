provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-west-2a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_lightsail_instance_snapshot" "example_snapshot" {
  name               = "example-snapshot"
  instance_name      = aws_lightsail_instance.example.name
  create_at          = "2023-10-01T00:00:00Z" # Example date, adjust as needed
  auto_snapshot_add  = true
}

resource "aws_lightsail_instance_auto_snapshot" "example_auto_snapshot" {
  instance_name = aws_lightsail_instance.example.name
  enabled       = true
}