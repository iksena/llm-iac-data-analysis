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

# Create Static IP
resource "aws_lightsail_static_ip" "example_static_ip" {
  name = "example-static-ip"
}

# Attach Static IP to Instance
resource "aws_lightsail_static_ip_attachment" "example_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_static_ip.name
  instance_name  = aws_lightsail_instance.example_instance.name
}

# Output the Static IP address
output "static_ip_address" {
  value = aws_lightsail_static_ip.example_static_ip.ip_address
  description = "The static IP address assigned to the Lightsail instance"
}