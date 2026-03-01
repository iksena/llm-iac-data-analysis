The Terraform program will set up an AWS Route 53 DNS record that maps a domain name to a specified IPv4 address. This involves creating a Route 53 hosted zone for the domain and then adding an A record to map the domain to the IPv4 address. The configuration will include the necessary provider setup for AWS.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "example" {
  name = "example.com"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "www.example.com"
  type    = "A"
  ttl     = "300"
  records = ["192.0.2.44"]
}
```
</iac_template>