To fulfill the business need, we will create a Terraform configuration that sets up an AWS Route 53 private hosted zone named "internal.example53.com" and associates it with a VPC. We will then create a non-alias Route 53 record within this hosted zone. The configuration will include the necessary AWS provider setup, VPC creation, Route 53 hosted zone creation, and the DNS record creation.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_route53_zone" "private_zone" {
  name = "internal.example53.com"
  vpc {
    vpc_id = aws_vpc.main.id
  }
}

resource "aws_route53_record" "example_record" {
  zone_id = aws_route53_zone.private_zone.zone_id
  name    = "app.internal.example53.com"
  type    = "A"
  ttl     = "300"
  records = ["10.0.0.10"]
}
```

</iac_template>

This configuration will create a VPC with a CIDR block of 10.0.0.0/16, a private Route 53 hosted zone named "internal.example53.com" associated with the VPC, and a non-alias A record "app.internal.example53.com" pointing to the IP address 10.0.0.10 within the hosted zone.