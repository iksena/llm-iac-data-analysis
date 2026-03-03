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