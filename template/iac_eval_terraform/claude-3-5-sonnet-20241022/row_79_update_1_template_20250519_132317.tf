provider "aws" {
  region = "us-east-1"
}

# Create Route 53 hosted zone
resource "aws_route53_zone" "main" {
  name = "example53.com"
}

# Create Route 53 record
resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "www.example53.com"
  type    = "A"
  ttl     = "300"
  records = ["192.0.2.1"]  # Example IP address
}