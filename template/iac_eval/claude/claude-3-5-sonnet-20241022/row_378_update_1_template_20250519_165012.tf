provider "aws" {
  region = "us-east-1" # Lightsail is available in us-east-1
}

# Create a Lightsail Instance
resource "aws_lightsail_instance" "web_server" {
  name              = "web-server-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"  # Smallest instance size

  user_data = <<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "<html><body><h1>Hello from Lightsail!</h1></body></html>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Environment = "Production"
  }
}

# Create a Lightsail Distribution
resource "aws_lightsail_distribution" "cdn_distribution" {
  name = "my-lightsail-distribution"
  
  origin {
    name        = "web-server-origin"
    region_name = "us-east-1"
    
    instance_port = 80
    
    protocol_policy  = "http-only"
    response_timeout = 30
    
    lightsail_instance_name = aws_lightsail_instance.web_server.name
  }

  default_cache_behavior {
    behavior = "cache"
    
    forwarded_cookies {
      option = "none"
    }
    
    forwarded_headers {
      option = "none"
    }
    
    forwarded_query_strings {
      option = false
    }
  }

  cache_behavior_settings {
    default_ttl = 86400    # 24 hours
    maximum_ttl = 31536000 # 1 year
    minimum_ttl = 0
  }

  bundle_id = "small"

  certificate_name = null # Using default certificate

  tags = {
    Environment = "Production"
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

# Output the Distribution URL
output "distribution_url" {
  value       = aws_lightsail_distribution.cdn_distribution.url
  description = "The URL of the Lightsail Distribution"
}

# Output the Instance Public IP
output "instance_public_ip" {
  value       = aws_lightsail_instance.web_server.public_ip_address
  description = "The public IP address of the Lightsail instance"
}