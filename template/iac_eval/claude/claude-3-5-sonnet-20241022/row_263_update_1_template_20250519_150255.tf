provider "aws" {
  region = "us-east-1"
}

# Create IAM User
resource "aws_iam_user" "basic_user" {
  name = "basic-user"
  path = "/"

  tags = {
    Description = "Basic IAM user with SSH key"
    CreatedBy   = "Terraform"
  }
}

# Generate SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Upload public SSH key to AWS
resource "aws_iam_user_ssh_key" "user_ssh_key" {
  username   = aws_iam_user.basic_user.name
  encoding   = "SSH"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Output the private key (Note: In production, handle this securely)
output "private_key" {
  value     = tls_private_key.ssh_key.private_key_pem
  sensitive = true
}

# Output the SSH key ID
output "ssh_key_id" {
  value = aws_iam_user_ssh_key.user_ssh_key.ssh_public_key_id
}

# Output the IAM user ARN
output "user_arn" {
  value = aws_iam_user.basic_user.arn
}