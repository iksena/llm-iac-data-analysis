I'll help you create a Terraform configuration for AWS Route 53 with a Geolocation routing policy that routes users to different endpoints based on their continent (US or EU). This configuration will include:

1. A Route 53 hosted zone named "primary"
2. Two record sets with geolocation routing policies (one for US and one for EU)
3. Appropriate A records pointing to example IP addresses for demonstration

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This configuration creates:

1. An AWS provider configured for the us-east-1 region
2. A Route 53 hosted zone for "primary.example.com"
3. Three A records with geolocation routing policies:
   - One for North American (NA) users pointing to 203.0.113.1
   - One for European (EU) users pointing to 203.0.113.2
   - A default record for all other locations pointing to 203.0.113.3

Each record has:
- A unique set_identifier (required for routing policies)
- A TTL of 300 seconds
- Example IP addresses (you should replace these with your actual endpoint IPs)

The configuration also includes an output that will display the nameservers assigned to your Route 53 zone.

Note: You'll need to replace the example IP addresses (203.0.113.x) with your actual endpoint IP addresses, and you may want to adjust the domain name "primary.example.com" to match your actual domain name.