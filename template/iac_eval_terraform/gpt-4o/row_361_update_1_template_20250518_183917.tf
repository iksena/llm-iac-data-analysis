provider "aws" {
  region = "us-west-2"
}

resource "aws_lightsail_instance" "example" {
  name              = "example-lightsail-instance"
  availability_zone = "us-west-2a"
  blueprint_id      = "amazon_linux_2" # Default blueprint for Amazon Linux 2
  bundle_id         = "nano_2_0"       # Smallest instance plan

  tags = {
    Name = "ExampleLightsailInstance"
  }
}