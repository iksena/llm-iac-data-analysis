provider "aws" {
  region = "us-west-2"
}

# Create IAM User
resource "aws_iam_user" "mfa_user" {
  name = "mfa_enabled_user"
  path = "/"
}

# Create Virtual MFA Device
resource "aws_iam_virtual_mfa_device" "virtual_mfa" {
  virtual_mfa_device_name = "virtual_mfa_device"
}

# Attach MFA Device to User
resource "aws_iam_user_mfa_device" "user_mfa" {
  user_name               = aws_iam_user.mfa_user.name
  serial_number          = aws_iam_virtual_mfa_device.virtual_mfa.arn
  authentication_code_1  = "000000"  # This should be replaced with actual MFA code
  authentication_code_2  = "000000"  # This should be replaced with actual MFA code
}

# Output the MFA Device ARN
output "mfa_device_arn" {
  value = aws_iam_virtual_mfa_device.virtual_mfa.arn
}

# Output the MFA Secret (Base32 encoded)
output "mfa_secret" {
  value     = aws_iam_virtual_mfa_device.virtual_mfa.base_32_string_seed
  sensitive = true
}