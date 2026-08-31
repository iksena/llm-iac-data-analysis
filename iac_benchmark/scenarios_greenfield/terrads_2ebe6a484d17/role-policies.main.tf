resource "aws_iam_policy" "state_store" {
  provider    = aws.eu_central_1
  name        = "utkusarioglu-com-state-store"
  path        = "/"
  description = "Allows minimal access for storing tf state in AWS S3"
  tags        = local.main_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Resource = "arn:aws:s3:::${aws_s3_bucket.state_store.bucket}"
        Action   = "s3:ListBucket",
      },
      {
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.state_store.bucket}/global/s3/terraform.tfstate"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ],
      },
    ]
  })
}

resource "aws_iam_policy" "state_lock" {
  provider    = aws.eu_central_1
  name        = "utkusarioglu-com-state-lock"
  path        = "/"
  description = "Allows minimal DynamoDB access to store and query tf state lock"
  tags        = local.main_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Resource = "arn:aws:dynamodb:*:*:table/${aws_dynamodb_table.state_lock.name}"
        Action = [
          "dynamodb:GetItem",
          "dynamodb:PutItem",
          "dynamodb:DeleteItem"
        ]
      }
    ]
  })
}

resource "aws_iam_policy" "main_static_content_write" {
  provider    = aws.eu_central_1
  name        = "utkusarioglu-com-static-content-write"
  path        = "/"
  description = "Allows adding and removing object to static content bucket"
  tags        = local.main_tags

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow",
        Resource = "arn:aws:s3:::${aws_s3_bucket.main_static_content.bucket}"
        Action = [
          "s3:ListBucket",
        ]
      },
      {
        Effect   = "Allow"
        Resource = "arn:aws:s3:::${aws_s3_bucket.main_static_content.bucket}/**"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:GetObjectTagging"
        ],
      },
    ]
  })
}
