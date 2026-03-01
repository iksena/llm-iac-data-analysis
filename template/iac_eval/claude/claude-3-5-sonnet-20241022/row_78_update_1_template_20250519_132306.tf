provider "aws" {
  region = "us-east-1"
}

# Create Route 53 hosted zone
resource "aws_route53_zone" "main" {
  name = "example53.com"

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
  }
}

# Output the name servers
output "name_servers" {
  description = "Name servers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}