provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "subnet_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet_b" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"
}

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

resource "aws_instance" "instance_a" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_a.id

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "InstanceA"
  }
}

resource "aws_instance" "instance_b" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.subnet_b.id

  root_block_device {
    volume_size = 50
  }

  tags = {
    Name = "InstanceB"
  }
}

resource "aws_security_group" "allow_ssh" {
  vpc_id = aws_vpc.main.id

  ingress {
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

resource "aws_network_interface_sg_attachment" "instance_a_sg" {
  security_group_id    = aws_security_group.allow_ssh.id
  network_interface_id = aws_instance.instance_a.primary_network_interface_id
}

resource "aws_network_interface_sg_attachment" "instance_b_sg" {
  security_group_id    = aws_security_group.allow_ssh.id
  network_interface_id = aws_instance.instance_b.primary_network_interface_id
}