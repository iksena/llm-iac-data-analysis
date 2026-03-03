Below is a description of the Terraform program and the complete HCL code.

Description:
This Terraform configuration creates a public Route 53 hosted zone named "primary.example.com" (the zone is called "primary"). Within that zone, two A-records are created for a subdomain (in this example, "app.primary.example.com")—one for each endpoint corresponding to the regions "us-east-1" and "eu-central-1". Both records use a weighted routing policy with equal weights (set to 1) so that Route 53 can route a user’s DNS request to whichever endpoint is deemed the “least congested” based on the weight settings. (In a live environment you might update the weights dynamically; here we initialize them equally.) Dummy IP addresses (192.0.2.1 for us-east-1 and 192.0.2.2 for eu-central-1) represent the actual endpoints. A valid AWS provider configuration is included with a default region of "us-east-1", and all needed variables are declared with default values.

The complete deployable Terraform HCL template is provided below.

<iac_template>
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "AWS region for the provider"
  default     = "us-east-1"
}

variable "domain_name" {
  description = "The primary domain name for the hosted zone"
  default     = "primary.example.com"
}

variable "record_name" {
  description = "Subdomain name for the application routing"
  default     = "app"
}

# Create a public Route 53 hosted zone named "primary.example.com"
resource "aws_route53_zone" "primary" {
  name = var.domain_name
  comment = "Hosted zone named primary for routing via weighted policy"
}

# A Record for the US East (us-east-1) endpoint using weighted routing
resource "aws_route53_record" "us_east_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "A"
  ttl     = 60

  weighted_routing_policy {
    weight         = 1
    set_identifier = "us-east-1"
  }

  # Dummy IP for the US East endpoint.
  records = ["192.0.2.1"]
}

# A Record for the EU Central (eu-central-1) endpoint using weighted routing
resource "aws_route53_record" "eu_central_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "${var.record_name}.${var.domain_name}"
  type    = "A"
  ttl     = 60

  weighted_routing_policy {
    weight         = 1
    set_identifier = "eu-central-1"
  }

  # Dummy IP for the EU Central endpoint.
  records = ["192.0.2.2"]
}
</iac_template>