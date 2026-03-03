Description: This Terraform configuration sets up an AWS provider in the "us-east-1" region and creates a Route53 hosted zone with the domain name "example53.com". The configuration is self-contained and deployable.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "example_zone" {
  name = "example53.com"
}
</iac_template>