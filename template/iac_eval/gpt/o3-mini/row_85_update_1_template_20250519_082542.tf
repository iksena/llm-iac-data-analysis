terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Create the Route 53 Hosted Zone named "primary" for the domain primary.com
resource "aws_route53_zone" "primary" {
  name = "primary.com"
}

# Record for US users
resource "aws_route53_record" "record_us" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.primary.com"
  type    = "A"
  ttl     = 60
  
  # Use geolocation routing for the United States
  geolocation {
    country_code = "US"
  }
  
  # Sample endpoint IP for US users; update as needed.
  records = [var.us_ip]
  
  set_identifier = "US-endpoint"
}

# Record for EU users
resource "aws_route53_record" "record_eu" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "app.primary.com"
  type    = "A"
  ttl     = 60
  
  # Use geolocation routing for the European continent
  geolocation {
    continent_code = "EU"
  }
  
  # Sample endpoint IP for EU users; update as needed.
  records = [var.eu_ip]

  set_identifier = "EU-endpoint"
}

# Variables for endpoint IP addresses with default values.
variable "us_ip" {
  description = "IP address for the US endpoint."
  type        = string
  default     = "1.2.3.4"
}

variable "eu_ip" {
  description = "IP address for the EU endpoint."
  type        = string
  default     = "5.6.7.8"
}