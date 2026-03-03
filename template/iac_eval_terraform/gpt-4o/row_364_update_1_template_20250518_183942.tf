provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  network {
    ipv6_address = true
  }
}

resource "aws_lightsail_static_ip" "example" {
  name = "example-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "example" {
  static_ip_name = aws_lightsail_static_ip.example.name
  instance_name  = aws_lightsail_instance.example.name
}

resource "aws_lightsail_domain" "example" {
  domain_name = "example.com"
}

resource "aws_lightsail_domain_entry" "example" {
  domain_name = aws_lightsail_domain.example.domain_name
  name        = "www"
  type        = "A"
  target      = aws_lightsail_static_ip.example.ip_address
}

resource "aws_lightsail_domain_entry" "example_ipv6" {
  domain_name = aws_lightsail_domain.example.domain_name
  name        = "www"
  type        = "AAAA"
  target      = aws_lightsail_instance.example.ipv6_address
}