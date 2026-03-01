To fulfill the business need of providing a Lightsail certificate, we will create a Terraform configuration that provisions an AWS Lightsail SSL/TLS certificate. This certificate can be used to enable HTTPS for a domain hosted on AWS Lightsail. The configuration will include the necessary provider setup and the Lightsail certificate resource. We will also specify the domain name for which the certificate is to be issued.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_certificate" "example" {
  name       = "example-certificate"
  domain_name = "example.com"
  subject_alternative_names = ["www.example.com"]

  tags = {
    Name = "example-lightsail-certificate"
  }
}
```
</iac_template>

This configuration sets up the AWS provider in the "us-east-1" region and creates a Lightsail certificate for the domain "example.com" with an additional subject alternative name "www.example.com". The certificate is tagged for easy identification.