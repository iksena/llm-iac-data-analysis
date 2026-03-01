provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
}

resource "aws_lightsail_static_ip" "example_ip" {
  name = "example-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "example_ip_attachment" {
  static_ip_name   = aws_lightsail_static_ip.example_ip.name
  instance_name    = aws_lightsail_instance.example.name
}