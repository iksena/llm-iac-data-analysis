provider "aws" {
  region = "us-west-2"
}

resource "aws_efs_file_system" "example" {
  creation_token = "example-efs"
  lifecycle_policy {
    transition_to_ia = "AFTER_30_DAYS"
  }

  tags = {
    Name = "example-efs"
  }
}

resource "aws_efs_mount_target" "example" {
  for_each = toset(["subnet-12345678", "subnet-87654321"])

  file_system_id  = aws_efs_file_system.example.id
  subnet_id       = each.key
  security_groups = [aws_security_group.efs_sg.id]
}

resource "aws_security_group" "efs_sg" {
  name        = "efs_sg"
  description = "Allow NFS traffic to EFS"
  vpc_id      = "vpc-12345678"

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

resource "aws_iam_role" "efs_role" {
  name = "efs_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticfilesystem.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "efs_policy" {
  name        = "efs_policy"
  description = "Policy for EFS access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticfilesystem:DescribeFileSystems",
          "elasticfilesystem:DescribeMountTargets",
          "elasticfilesystem:DescribeTags"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "efs_policy_attachment" {
  role       = aws_iam_role.efs_role.name
  policy_arn = aws_iam_policy.efs_policy.arn
}