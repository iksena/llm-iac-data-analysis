provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"

  tags = {
    Name = "example-lightsail-instance"
  }
}

# Enable IPv6 on the instance
resource "aws_lightsail_instance_public_ports" "example_ports" {
  instance_name = aws_lightsail_instance.example_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
    cidrs     = ["0.0.0.0/0", "::/0"]
  }

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
    cidrs     = ["0.0.0.0/0", "::/0"]
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
    cidrs     = ["0.0.0.0/0", "::/0"]
  }
}

# Create static IP
resource "aws_lightsail_static_ip" "example_static_ip" {
  name = "example-static-ip"
}

# Attach static IP to instance
resource "aws_lightsail_static_ip_attachment" "example_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_static_ip.name
  instance_name  = aws_lightsail_instance.example_instance.name
}

# Output the public IP addresses
output "ipv4_address" {
  value = aws_lightsail_static_ip.example_static_ip.ip_address
}

output "instance_ipv6_addresses" {
  value = aws_lightsail_instance.example_instance.ipv6_addresses
}