provider "aws" {
  region = "us-west-2"
}

# Create IAM User
resource "aws_iam_user" "demo_user" {
  name = "demo-user"
  path = "/"

  tags = {
    Environment = "Production"
    Team        = "DevOps"
  }
}

# Create IAM Policy
resource "aws_iam_policy" "read_only_policy" {
  name        = "read-only-policy"
  description = "A read-only policy for demo user"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ec2:Describe*",
          "s3:List*",
          "s3:Get*",
          "rds:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach policy to user
resource "aws_iam_user_policy_attachment" "policy_attachment" {
  user       = aws_iam_user.demo_user.name
  policy_arn = aws_iam_policy.read_only_policy.arn
}

# Create access keys for the user
resource "aws_iam_access_key" "user_access_key" {
  user = aws_iam_user.demo_user.name
}

# Output the access key ID (Secret key is only available in state file)
output "access_key_id" {
  value = aws_iam_access_key.user_access_key.id
}

# Output the user ARN
output "user_arn" {
  value = aws_iam_user.demo_user.arn
}