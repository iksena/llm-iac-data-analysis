# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Data source to fetch latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}

# Output the AMI ID
output "amazon_linux_2_ami_id" {
  description = "ID of the latest Amazon Linux 2 AMI"
  value       = data.aws_ami.amazon_linux_2.id
}

# Output the AMI Name
output "amazon_linux_2_ami_name" {
  description = "Name of the latest Amazon Linux 2 AMI"
  value       = data.aws_ami.amazon_linux_2.name
}