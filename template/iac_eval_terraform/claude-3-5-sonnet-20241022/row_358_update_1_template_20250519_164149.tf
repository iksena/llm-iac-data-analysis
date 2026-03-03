provider "aws" {
  region = "us-east-1"
}

# Create a new Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"  # 1 GB RAM, 1 vCPU

  tags = {
    Environment = "Development"
    ManagedBy   = "Terraform"
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get upgrade -y
              EOF
}

# Create a static IP for the Lightsail instance
resource "aws_lightsail_static_ip" "example_static_ip" {
  name = "example-static-ip"
}

# Attach static IP to the instance
resource "aws_lightsail_static_ip_attachment" "example_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_static_ip.name
  instance_name  = aws_lightsail_instance.example_instance.name
}

# Output the public IP address
output "instance_public_ip" {
  value = aws_lightsail_static_ip.example_static_ip.ip_address
}

# Output the instance username
output "instance_username" {
  value = "ubuntu"
}