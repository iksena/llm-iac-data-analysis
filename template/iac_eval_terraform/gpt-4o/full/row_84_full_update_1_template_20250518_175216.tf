To address the business need, we will configure an Amazon Route 53 routing policy that directs users to the least congested endpoint. This will be achieved using a latency-based routing policy. We will create a Route 53 hosted zone named "primary" and define two records, each pointing to an endpoint in different AWS regions: "us-east-1" and "eu-central-1". The latency-based routing policy will ensure that users are directed to the endpoint that provides the lowest latency, effectively navigating them to the least congested endpoint.

Here is the Terraform HCL configuration:

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "primary"
}

resource "aws_route53_record" "us_east_1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "us-east-1.primary"
  type    = "A"
  set_identifier = "us-east-1"
  latency_routing_policy {
    region = "us-east-1"
  }
  ttl     = 60
  records = ["192.0.2.1"] # Replace with the actual IP address of the endpoint in us-east-1
}

resource "aws_route53_record" "eu_central_1" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "eu-central-1.primary"
  type    = "A"
  set_identifier = "eu-central-1"
  latency_routing_policy {
    region = "eu-central-1"
  }
  ttl     = 60
  records = ["192.0.2.2"] # Replace with the actual IP address of the endpoint in eu-central-1
}
```
</iac_template>

This configuration sets up a Route 53 hosted zone named "primary" and creates two A records with latency-based routing policies. Each record is associated with a specific AWS region, ensuring that users are directed to the endpoint with the lowest latency. The IP addresses in the records should be replaced with the actual IP addresses of the endpoints in the respective regions.