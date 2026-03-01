provider "aws" {
  region = "us-east-1"
}

# Create Route 53 zone
resource "aws_route53_zone" "main" {
  name = "example"
}

# Create TXT record for domain verification
resource "aws_route53_record" "txt_verify" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "example"
  type    = "TXT"
  ttl     = "300"
  records = ["passwordpassword"]
}

# Output the name servers
output "nameservers" {
  description = "Nameservers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}