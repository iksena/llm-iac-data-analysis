provider "aws" {
  region = "us-east-1"
}

# Variables
variable "index_name" {
  description = "Name of the Kendra index"
  type        = string
  default     = "my-kendra-index"
}

variable "data_source_name" {
  description = "Name of the Kendra data source"
  type        = string
  default     = "my-web-crawler"
}

# Create IAM role for Kendra
resource "aws_iam_role" "kendra_role" {
  name = "kendra-index-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
      }
    ]
  })
}

# Attach required policies to the IAM role
resource "aws_iam_role_policy" "kendra_policy" {
  name = "kendra-index-policy"
  role = aws_iam_role.kendra_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData"
        ]
        Resource = "*"
        Condition = {
          StringEquals = {
            "cloudwatch:namespace" = "AWS/Kendra"
          }
        }
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogGroups",
          "logs:CreateLogGroup"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/kendra/*"
      },
      {
        Effect = "Allow"
        Action = [
          "logs:DescribeLogStreams",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:log-group:/aws/kendra/*:log-stream:*"
      }
    ]
  })
}

# Create Kendra Index
resource "aws_kendra_index" "example" {
  name        = var.index_name
  description = "Example Kendra Index"
  role_arn    = aws_iam_role.kendra_role.arn

  edition = "DEVELOPER_EDITION"
}

# Create Kendra Data Source
resource "aws_kendra_data_source" "example" {
  index_id = aws_kendra_index.example.id
  name     = var.data_source_name
  type     = "WEBCRAWLER"
  role_arn = aws_iam_role.kendra_role.arn

  web_crawler_configuration {
    urls {
      seed_url_configuration {
        seed_urls = ["https://example.com"]
        web_crawler_mode = "HOST_ONLY"
      }

      url_inclusion_patterns = [
        "https://example.com/docs/*",
        "https://example.com/blog/*"
      ]

      url_exclusion_patterns = [
        "https://example.com/docs/internal/*",
        "https://example.com/blog/draft/*"
      ]
    }

    crawl_depth = 2
  }

  language_code = "en"
  description   = "Web crawler data source with URL patterns"
}