provider "aws" {
  region = "us-east-1"
}

# Create Route 53 Zone
resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

# Create Record Set for US users
resource "aws_route53_record" "us" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.primary.example.com"
  type    = "A"
  ttl     = "300"
  records = ["203.0.113.1"] # Example IP for US endpoint

  geolocation_routing_policy {
    continent = "NA"
  }

  set_identifier = "us"
}

# Create Record Set for EU users
resource "aws_route53_record" "eu" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.primary.example.com"
  type    = "A"
  ttl     = "300"
  records = ["203.0.113.2"] # Example IP for EU endpoint

  geolocation_routing_policy {
    continent = "EU"
  }

  set_identifier = "eu"
}

# Create a default record for users from other locations
resource "aws_route53_record" "default" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "www.primary.example.com"
  type    = "A"
  ttl     = "300"
  records = ["203.0.113.3"] # Example IP for default endpoint

  geolocation_routing_policy {
    country = "*"
  }

  set_identifier = "default"
}

# Output the nameservers
output "nameservers" {
  value = aws_route53_zone.primary.name_servers
  description = "Nameservers for the Route 53 zone"
}