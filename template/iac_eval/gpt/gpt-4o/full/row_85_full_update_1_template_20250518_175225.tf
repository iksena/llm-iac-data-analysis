To address the business need, we will create a Route 53 hosted zone named "primary" and configure a routing policy that uses geolocation to direct users to the nearest endpoint based on their continent. We will define two geolocation records: one for users in the "US" continent and another for users in the "EU" continent. Each record will point to a different endpoint, which could be an IP address or a domain name representing the nearest server or service endpoint for that region.

The Terraform configuration will include:
- A Route 53 hosted zone named "primary".
- Geolocation routing records for the "US" and "EU" continents.

We will use the AWS provider to manage these resources.

```hcl
<iac_template>
provider "aws" {
  region = "us-east-1"
}

resource "aws_route53_zone" "primary" {
  name = "primary.example.com"
}

resource "aws_route53_record" "us_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "us.primary.example.com"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.1"] # Replace with the actual US endpoint IP or domain

  geolocation_routing_policy {
    continent = "NA"
  }
}

resource "aws_route53_record" "eu_record" {
  zone_id = aws_route53_zone.primary.zone_id
  name    = "eu.primary.example.com"
  type    = "A"
  ttl     = 300
  records = ["192.0.2.2"] # Replace with the actual EU endpoint IP or domain

  geolocation_routing_policy {
    continent = "EU"
  }
}
</iac_template>
```

This configuration sets up a Route 53 hosted zone and two geolocation routing records. Users from North America (NA) will be directed to the US endpoint, and users from Europe (EU) will be directed to the EU endpoint. Adjust the IP addresses or domain names in the `records` attribute to match your actual endpoints.