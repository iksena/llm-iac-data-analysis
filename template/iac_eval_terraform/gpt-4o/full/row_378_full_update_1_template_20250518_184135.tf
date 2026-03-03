To manage an AWS Lightsail Distribution with an instance as an origin, we will create a Terraform configuration that sets up a Lightsail instance and a Lightsail distribution. The instance will serve as the origin for the distribution. We will configure the necessary IAM roles and policies to allow the distribution to access the instance. The configuration will include the AWS provider setup, Lightsail instance, and Lightsail distribution resources. We will also specify default values for any variables used in the configuration.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_lightsail_distribution" "example" {
  name = "example-distribution"

  origin {
    name = aws_lightsail_instance.example.name
    protocol_policy = "https-only"
  }

  default_cache_behavior {
    behavior = "cache"
  }

  tags = {
    Name = "ExampleDistribution"
  }
}

output "instance_public_ip" {
  value = aws_lightsail_instance.example.public_ip_address
}

output "distribution_url" {
  value = aws_lightsail_distribution.example.alternate_domain_names
}
```
</iac_template>

This configuration sets up a Lightsail instance with Amazon Linux 2 and a nano bundle. It also creates a Lightsail distribution with the instance as its origin, using HTTPS for communication. The outputs provide the public IP address of the instance and the URL of the distribution.