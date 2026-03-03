terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = "us-east-1"
}

variable "instance_name" {
  description = "Name of the Lightsail instance"
  type        = string
  default     = "example-lightsail-instance"
}

variable "availability_zone" {
  description = "Availability zone for the Lightsail instance"
  type        = string
  default     = "us-east-1a"
}

resource "aws_lightsail_instance" "example_instance" {
  name              = var.instance_name
  availability_zone = var.availability_zone
  blueprint_id      = "amazon_linux_2"
  bundle_id         = "nano_2_0"

  tags = {
    Environment = "Production"
    Name        = var.instance_name
  }
}

resource "aws_lightsail_instance_automatic_snapshot" "example_auto_snapshot" {
  instance_name = aws_lightsail_instance.example_instance.name
  time_of_day   = "06:00"
}

resource "aws_lightsail_static_ip" "example_static_ip" {
  name = "${var.instance_name}-static-ip"
}

resource "aws_lightsail_static_ip_attachment" "example_static_ip_attachment" {
  static_ip_name = aws_lightsail_static_ip.example_static_ip.name
  instance_name  = aws_lightsail_instance.example_instance.name
}

output "instance_public_ip" {
  description = "Public IP address of the Lightsail instance"
  value       = aws_lightsail_static_ip.example_static_ip.ip_address
}

output "instance_arn" {
  description = "ARN of the Lightsail instance"
  value       = aws_lightsail_instance.example_instance.arn
}