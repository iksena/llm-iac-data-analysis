terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_lightsail_instance" "main" {
  name              = "my-lightsail-instance"
  availability_zone = "us-east-1a"
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"
}

# Enable automatic snapshots using the correct resource type
resource "aws_lightsail_instance_snapshot" "auto_snapshot" {
  instance_name      = aws_lightsail_instance.main.name
  snapshot_name      = "${aws_lightsail_instance.main.name}-snapshot"
  depends_on         = [aws_lightsail_instance.main]
}