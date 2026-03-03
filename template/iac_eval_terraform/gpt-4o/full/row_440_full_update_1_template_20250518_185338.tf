To fulfill the business need, we will create an egress-only internet gateway named "pike" in a specified VPC. This gateway will allow IPv6-enabled instances within the VPC to connect to the internet while preventing inbound internet traffic. We will also tag the egress-only internet gateway with the key "Name" and value "pike" and another tag "permissions" to meet the tagging requirement. The configuration will include the necessary provider setup and VPC resource definition.

<iac_template>

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "example-vpc"
  }
}

resource "aws_egress_only_internet_gateway" "pike" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name        = "pike"
    permissions = "egress-only"
  }
}
```

</iac_template>

This configuration sets up an AWS VPC and an egress-only internet gateway named "pike" associated with the VPC. The gateway is tagged appropriately, and the provider is configured to use the "us-east-1" region.