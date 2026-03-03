To create a basic AWS IAM Virtual MFA Device using Terraform, we will define a configuration that sets up an IAM user and associates a virtual MFA device with that user. This setup is useful for enhancing the security of the IAM user by requiring multi-factor authentication. The configuration will include the necessary IAM user, the virtual MFA device, and the provider configuration for AWS.

<iac_template>
```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_user" "example_user" {
  name = "example-user"
}

resource "aws_iam_virtual_mfa_device" "example_mfa" {
  virtual_mfa_device_name = "${aws_iam_user.example_user.name}_mfa"
  path                    = "/"
}

resource "aws_iam_user_policy" "allow_mfa_device" {
  name = "AllowMFADevice"
  user = aws_iam_user.example_user.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "iam:ListVirtualMFADevices"
        Resource = "*"
      },
      {
        Effect   = "Allow"
        Action   = [
          "iam:EnableMFADevice",
          "iam:DeactivateMFADevice",
          "iam:ResyncMFADevice"
        ]
        Resource = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:mfa/${aws_iam_virtual_mfa_device.example_mfa.virtual_mfa_device_name}"
      }
    ]
  })
}

data "aws_caller_identity" "current" {}
```
</iac_template>

This configuration sets up an IAM user named "example-user" and a virtual MFA device associated with that user. It also includes a policy that allows the user to manage their MFA device. The AWS provider is configured to use the "us-east-1" region.