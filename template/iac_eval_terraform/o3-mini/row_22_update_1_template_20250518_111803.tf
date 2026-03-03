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

# Variable for the IP address for which the PTR record will be set up.
variable "reverse_ip" {
  description = "The IP address to create the reverse DNS PTR record for."
  type        = string
  default     = "10.0.0.1"
}

# For this example, we assume the reverse DNS zone corresponds to the /24 network 
# for the IP address 10.0.0.1 which is 10.0.0.0/24. The zone is named "0.0.10.in-addr.arpa".
resource "aws_route53_zone" "reverse_zone" {
  name    = "0.0.10.in-addr.arpa"
  comment = "Reverse DNS zone for the 10.0.0.0/24 network."
}

# Create a PTR record that points to the canonical hostname "host.example53.com".
# For an IP "10.0.0.1", the reverse lookup record is "1.0.0.10.in-addr.arpa".
resource "aws_route53_record" "ptr_record" {
  zone_id = aws_route53_zone.reverse_zone.zone_id
  name    = "1"  # This creates the full record name "1.0.0.10.in-addr.arpa"
  type    = "PTR"
  ttl     = 300

  # The PTR record value must be a fully qualified domain name (ending with a trailing dot).
  records = ["host.example53.com."]
}