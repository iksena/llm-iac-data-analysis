provider "aws" {
  region = "us-east-1"
}

# Create Lightsail Instance with WordPress
resource "aws_lightsail_instance" "wordpress_instance" {
  name              = "wordpress-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "wordpress"
  bundle_id         = "nano_2_0"  # 1 GB RAM, 1 vCPU

  tags = {
    Environment = "Production"
    Application = "WordPress"
  }
}

# Create static IP for the instance
resource "aws_lightsail_static_ip" "wordpress_static_ip" {
  name = "wordpress-static-ip"
}

# Attach static IP to the instance
resource "aws_lightsail_static_ip_attachment" "wordpress_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.wordpress_static_ip.name
  instance_name  = aws_lightsail_instance.wordpress_instance.name
}

# Open required ports for WordPress
resource "aws_lightsail_instance_public_ports" "wordpress_ports" {
  instance_name = aws_lightsail_instance.wordpress_instance.name

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }

  port_info {
    protocol  = "tcp"
    from_port = 443
    to_port   = 443
  }

  port_info {
    protocol  = "tcp"
    from_port = 22
    to_port   = 22
  }
}

# Output the public IP address
output "wordpress_public_ip" {
  value = aws_lightsail_static_ip.wordpress_static_ip.ip_address
}

output "wordpress_instance_name" {
  value = aws_lightsail_instance.wordpress_instance.name
}