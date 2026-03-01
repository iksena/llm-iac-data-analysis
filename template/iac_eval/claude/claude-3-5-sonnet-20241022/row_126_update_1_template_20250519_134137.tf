provider "aws" {
  region = "us-east-1"
}

# Data source for the latest Amazon Linux 2 AMI
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
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

# Create EC2 instance with specified CPU configuration
resource "aws_instance" "example" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.large"  # This instance type supports the required CPU configuration

  cpu_options {
    core_count       = 2
    threads_per_core = 2
  }

  tags = {
    Name = "Amazon-Linux-2-Instance"
  }
}

# Output the AMI ID
output "ami_id" {
  value = data.aws_ami.amazon_linux_2.id
}

# Output the instance ID
output "instance_id" {
  value = aws_instance.example.id
}