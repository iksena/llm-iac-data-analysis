provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_lightsail_distribution" "example" {
  name = "example-distribution"

  origin {
    name = aws_lightsail_instance.example.name
    protocol_policy = "https-only"
  }

  default_cache_behavior {
    behavior = "cache"
  }

  tags = {
    Name = "ExampleDistribution"
  }
}

output "instance_public_ip" {
  value = aws_lightsail_instance.example.public_ip_address
}

output "distribution_url" {
  value = aws_lightsail_distribution.example.alternate_domain_names
}