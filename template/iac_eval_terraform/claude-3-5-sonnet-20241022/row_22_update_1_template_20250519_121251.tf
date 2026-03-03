provider "aws" {
  region = "us-east-1"
}

# Create Route 53 Reverse DNS Zone
resource "aws_route53_zone" "reverse_zone" {
  name = "1.168.192.in-addr.arpa" # Example reverse DNS zone for 192.168.1.0/24

  tags = {
    Name = "reverse_zone"
  }
}

# Create PTR Record
resource "aws_route53_record" "ptr_record" {
  zone_id = aws_route53_zone.reverse_zone.zone_id
  name    = "10.1.168.192.in-addr.arpa" # Example: PTR record for IP 192.168.1.10
  type    = "PTR"
  ttl     = "300"
  records = ["host.example53.com"]
}

# Output the name servers for the reverse zone
output "reverse_zone_name_servers" {
  value = aws_route53_zone.reverse_zone.name_servers
}