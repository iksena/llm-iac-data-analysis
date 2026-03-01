To fulfill the business need, we will create a Terraform configuration that sets up an AWS Route 53 hosted zone for the domain "example53.com" and then creates a non-alias A record within that hosted zone. This A record will point to a specific IP address. We will use the AWS provider to manage the Route 53 resources. The configuration will include the necessary provider setup and resource definitions.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "example" {
  name = "example53.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "www.example53.com"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.44"]  # Example IP address
}
```
</iac_template>

This configuration will create a Route 53 hosted zone for "example53.com" and a non-alias A record for "www.example53.com" pointing to the IP address "192.0.2.44". The TTL for the DNS record is set to 300 seconds.