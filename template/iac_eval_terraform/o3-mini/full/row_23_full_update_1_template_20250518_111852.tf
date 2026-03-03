Description:
This Terraform configuration creates an AWS Route 53 hosted zone with the domain name "example" and then creates a TXT record in that zone for domain ownership verification. The TXT record contains the verification string "passwordpassword". The AWS provider is configured to use the "us-east-1" region. All necessary resources are declared and there are no undeclared references.

<iac_template>
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

resource "aws_route53_zone" "example_zone" {
  name = "example"
}

resource "aws_route53_record" "txt_verification" {
  zone_id = aws_route53_zone.example_zone.zone_id
  # Here, setting the record name to the zone's apex.
  name    = aws_route53_zone.example_zone.name
  type    = "TXT"
  ttl     = 300

  # TXT records require the value to be quoted.
  records = ["\"passwordpassword\""]
}
</iac_template>