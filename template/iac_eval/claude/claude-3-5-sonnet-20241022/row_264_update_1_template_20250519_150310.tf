provider "aws" {
  region = "us-west-2"
}

# Create IAM Group
resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/"
}

# Create IAM Policy
resource "aws_iam_policy" "s3_read_only" {
  name        = "s3_read_only"
  description = "S3 read-only access policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:Get*",
          "s3:List*",
          "s3:Describe*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Attach Policy to Group
resource "aws_iam_group_policy_attachment" "developers_policy" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.s3_read_only.arn
}

# Create IAM User
resource "aws_iam_user" "example_user" {
  name = "example_developer"
  path = "/"
}

# Add User to Group
resource "aws_iam_user_group_membership" "example_user_group" {
  user = aws_iam_user.example_user.name
  groups = [
    aws_iam_group.developers.name
  ]
}

# Create access key for the user
resource "aws_iam_access_key" "example_user_key" {
  user = aws_iam_user.example_user.name
}

# Output the access key ID (the secret key will be available in the state file)
output "access_key_id" {
  value = aws_iam_access_key.example_user_key.id
}