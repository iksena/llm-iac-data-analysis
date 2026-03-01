provider "aws" {
  region = "us-west-2"
}

resource "aws_efs_file_system" "example" {
  creation_token = "example-efs-token"

  tags = {
    Name        = "example-efs"
    Environment = "production"
    Project     = "example-project"
  }
}

resource "aws_security_group" "efs_sg" {
  name        = "efs-security-group"
  description = "Allow NFS traffic"

  ingress {
    from_port   = 2049
    to_port     = 2049
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

resource "aws_efs_mount_target" "example" {
  for_each          = toset(data.aws_subnet_ids.all.ids)
  file_system_id    = aws_efs_file_system.example.id
  subnet_id         = each.value
  security_groups   = [aws_security_group.efs_sg.id]
}

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_vpc" "default" {
  default = true
}