I'll help you create a Terraform configuration to set up a DNS A record in Amazon Route 53 that maps a domain name to an IPv4 address.

Description:
This Terraform configuration will:
1. Create a Route 53 hosted zone for your domain
2. Create an A record within the hosted zone that points to a specified IPv4 address
3. Use variables to make the domain name and IP address configurable

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Variables
variable "domain_name" {
  description = "The domain name for the hosted zone"
  type        = string
  default     = "example.com"
}

variable "subdomain" {
  description = "The subdomain to create the A record for"
  type        = string
  default     = "www"
}

variable "target_ip" {
  description = "The IPv4 address to point the A record to"
  type        = string
  default     = "203.0.113.1"  # Example IP address
}

# Create Route 53 hosted zone
resource "aws_route53_zone" "main" {
  name = var.domain_name
}

# Create A record
resource "aws_route53_record" "a_record" {
  zone_id = aws_route53_zone.main.zone_id
  name    = "${var.subdomain}.${var.domain_name}"
  type    = "A"
  ttl     = 300
  records = [var.target_ip]
}

# Output the nameservers
output "nameservers" {
  description = "Nameservers for the hosted zone"
  value       = aws_route53_zone.main.name_servers
}
</iac_template>

This configuration creates:
1. An AWS provider configuration for the us-east-1 region
2. Three variables for customization:
   - domain_name: The main domain name
   - subdomain: The subdomain prefix
   - target_ip: The IPv4 address to point to
3. A Route 53 hosted zone for your domain
4. An A record that maps your subdomain to the specified IP address
5. An output that displays the nameservers for your hosted zone

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Review the changes: `terraform plan`
3. Apply the configuration: `terraform apply`

You can customize the domain name, subdomain, and IP address by either:
1. Modifying the default values in the variables
2. Passing them as command-line arguments
3. Creating a terraform.tfvars file

Note: After creating the hosted zone, you'll need to update your domain's nameservers at your domain registrar to match the nameservers provided in the output.