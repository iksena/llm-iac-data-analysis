provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_certificate" "example" {
  name       = "example-certificate"
  domain_name = "example.com"
  subject_alternative_names = ["www.example.com"]

  tags = {
    Name = "example-lightsail-certificate"
  }
}