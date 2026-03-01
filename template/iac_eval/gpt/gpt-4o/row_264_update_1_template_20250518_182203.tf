provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_group" "example_group" {
  name = "example-group"
}

resource "aws_iam_policy" "example_policy" {
  name        = "example-policy"
  description = "A test policy"
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

resource "aws_iam_group_policy_attachment" "example_attachment" {
  group      = aws_iam_group.example_group.name
  policy_arn = aws_iam_policy.example_policy.arn
}