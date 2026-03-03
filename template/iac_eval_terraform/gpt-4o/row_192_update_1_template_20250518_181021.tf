provider "aws" {
  region = "us-east-1"
}

resource "aws_placement_group" "cluster_pg" {
  name     = "my-cluster-placement-group"
  strategy = "cluster"
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"

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
}

resource "aws_instance" "cluster_instances" {
  count = 3

  ami                    = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (example)
  instance_type          = "t2.micro"
  placement_group        = aws_placement_group.cluster_pg.name
  security_groups        = [aws_security_group.allow_ssh.name]

  tags = {
    Name = "ClusterInstance-${count.index}"
  }
}