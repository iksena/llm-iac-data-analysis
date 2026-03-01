provider "aws" {
  region = "us-west-2"
}

# Create IAM User
resource "aws_iam_user" "mfa_user" {
  name = "mfa_enabled_user"
  path = "/"

  tags = {
    Description = "User with MFA device"
  }
}

# Create Virtual MFA Device
resource "aws_iam_virtual_mfa_device" "example" {
  virtual_mfa_device_name = "example_virtual_mfa_device"

  tags = {
    Description = "Virtual MFA Device"
  }
}

# Output the Virtual MFA Device ARN
output "virtual_mfa_device_arn" {
  value = aws_iam_virtual_mfa_device.example.arn
}

# Output the IAM User ARN
output "iam_user_arn" {
  value = aws_iam_user.mfa_user.arn
}