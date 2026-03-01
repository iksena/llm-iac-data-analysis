provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "glacier_access_role" {
  name = "GlacierAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "glacier.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "glacier_access_policy" {
  name        = "GlacierAccessPolicy"
  description = "Policy to allow access to Glacier vault"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "glacier:InitiateJob",
          "glacier:GetJobOutput",
          "glacier:DeleteArchive",
          "glacier:UploadArchive",
          "glacier:DescribeVault",
          "glacier:ListVaults"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "glacier_access_policy_attachment" {
  role       = aws_iam_role.glacier_access_role.name
  policy_arn = aws_iam_policy.glacier_access_policy.arn
}

resource "aws_glacier_vault" "archive_vault" {
  name = "long-term-archive-vault"
}