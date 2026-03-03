To fulfill the business need, we will create an Amazon Lightsail instance using Terraform. We will also generate a new SSH key pair specifically for this instance to ensure secure access. The configuration will include the necessary provider setup for AWS, the creation of the SSH key pair, and the deployment of the Lightsail instance using this key. The instance will be created in the `us-east-1` region.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_lightsail_key_pair" "example" {
  name       = "example-key-pair"
  public_key = tls_private_key.example.public_key_openssh
}

resource "aws_lightsail_instance" "example" {
  name              = "example-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  key_pair_name = aws_lightsail_key_pair.example.name
}

output "private_key_pem" {
  value     = tls_private_key.example.private_key_pem
  sensitive = true
}

output "instance_ip" {
  value = aws_lightsail_instance.example.public_ip_address
}
```
</iac_template>

This configuration will create a new RSA SSH key pair, store the public key in AWS Lightsail, and use it to launch a new Lightsail instance with the Amazon Linux 2 blueprint and a nano bundle. The private key is outputted as a sensitive value for secure access to the instance.