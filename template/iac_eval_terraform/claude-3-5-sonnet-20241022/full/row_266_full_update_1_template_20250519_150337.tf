I'll help you create a Terraform configuration to set up an AWS IAM Virtual MFA Device resource. This configuration will:

1. Create an AWS provider configuration
2. Create an IAM user
3. Create a virtual MFA device and associate it with the IAM user
4. Output the MFA device ARN and secret configuration code

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

Important Notes:
1. This configuration creates a basic virtual MFA device setup in AWS.
2. The authentication_code_1 and authentication_code_2 values are set to "000000" as placeholders. In a real deployment, you would need to:
   - Get the base32_string_seed
   - Configure it in your MFA app (like Google Authenticator)
   - Generate two consecutive MFA codes
   - Replace the placeholder values with actual MFA codes
3. The MFA secret is marked as sensitive in the output to prevent accidental exposure.
4. The configuration uses the us-west-2 region, but you can modify this as needed.
5. Make sure you have appropriate AWS credentials configured to execute this template.

To use this configuration:
1. Initialize Terraform: `terraform init`
2. Plan the changes: `terraform plan`
3. Apply the configuration: `terraform apply`

Remember to properly secure the MFA secret and update the authentication codes with valid values before applying the configuration in a production environment.