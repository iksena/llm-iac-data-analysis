provider "aws" {
  region = "us-west-2"
}

# Create IAM Group
resource "aws_iam_group" "developers" {
  name = "developers"
  path = "/"
}

# Create IAM Policy
resource "aws_iam_policy" "developer_policy" {
  name        = "developer_policy"
  description = "Policy for developers group"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Resource = [
          "arn:aws:s3:::*",
          "arn:aws:s3:::*/*"
        ]
      }
    ]
  })
}

# Attach Policy to Group
resource "aws_iam_group_policy_attachment" "developer_policy_attach" {
  group      = aws_iam_group.developers.name
  policy_arn = aws_iam_policy.developer_policy.arn
}