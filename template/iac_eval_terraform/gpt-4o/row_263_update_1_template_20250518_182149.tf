provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "basic_user" {
  name = "basic-ssh-user"
}

resource "aws_iam_access_key" "basic_user_key" {
  user = aws_iam_user.basic_user.name
}

resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_iam_user_ssh_key" "basic_user_ssh_key" {
  username   = aws_iam_user.basic_user.name
  encoding   = "SSH"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

resource "aws_iam_policy" "basic_policy" {
  name        = "basic-policy"
  description = "A basic policy for listing S3 buckets"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "s3:ListBucket"
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "basic_user_policy_attachment" {
  user       = aws_iam_user.basic_user.name
  policy_arn = aws_iam_policy.basic_policy.arn
}

output "private_key_pem" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

output "public_key_openssh" {
  value = tls_private_key.ssh_key.public_key_openssh
}

output "access_key_id" {
  value = aws_iam_access_key.basic_user_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.basic_user_key.secret
  sensitive = true
}