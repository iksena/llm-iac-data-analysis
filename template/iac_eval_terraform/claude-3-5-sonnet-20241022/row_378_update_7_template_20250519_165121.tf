provider "aws" {
  region = "us-east-1"
}

# Create a Lightsail Instance
resource "aws_lightsail_instance" "web_server" {
  name              = "web-server-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<html><body><h1>Hello from Lightsail!</h1></body></html>" > /var/www/html/index.html
              EOF
}

# Create a Lightsail Distribution
resource "aws_lightsail_distribution" "cdn_distribution" {
  name      = "my-distribution"
  bundle_id = "small_1_0"
  
  origin {
    name            = aws_lightsail_instance.web_server.name
    region_name     = "us-east-1"
    protocol_policy = "http-only"
  }

  default_cache_behavior {
    behavior = "cache"
  }

  cache_behavior_settings {
    default_ttl = 86400
    maximum_ttl = 31536000
    minimum_ttl = 0
  }
}

# Open HTTP port on the instance
resource "aws_lightsail_instance_public_ports" "web_server_ports" {
  instance_name = aws_lightsail_instance.web_server.name

  port_info {
    protocol  = "tcp"
    from_port = 80
    to_port   = 80
  }
}

output "instance_public_ip" {
  value = aws_lightsail_instance.web_server.public_ip_address
}

output "distribution_domain_name" {
  value = aws_lightsail_distribution.cdn_distribution.domain_name
}