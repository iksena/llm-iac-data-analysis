provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Instance
resource "aws_lightsail_instance" "example_instance" {
  name              = "example-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "ubuntu_20_04"
  bundle_id         = "nano_2_0"  # 1 GB RAM, 1 vCPU

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Environment = "Development"
  }
}

# Open ports for the instance
resource "aws_lightsail_instance_public_ports" "example_ports" {
  instance_name = aws_lightsail_instance.example_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }
}

# Output the public IP address
output "public_ip" {
  value = aws_lightsail_instance.example_instance.public_ip_address
}

# Output the instance URL
output "instance_url" {
  value = "http://${aws_lightsail_instance.example_instance.public_ip_address}"
}