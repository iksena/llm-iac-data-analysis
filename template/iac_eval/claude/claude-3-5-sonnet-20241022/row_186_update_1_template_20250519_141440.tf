provider "aws" {
  region = "us-east-1"
}

# Get the latest Amazon Linux 2 AMI
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
}

# Create a security group
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh"
  }
}

# Create EC2 instance
resource "aws_instance" "linux_instance" {
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t3.medium"

  cpu_core_count       = 2
  cpu_threads_per_core = 2

  security_groups = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "AmazonLinux2-Instance"
  }

  root_block_device {
    volume_size = 8
    volume_type = "gp2"
  }
}

# Output the instance public IP
output "instance_public_ip" {
  value = aws_instance.linux_instance.public_ip
}