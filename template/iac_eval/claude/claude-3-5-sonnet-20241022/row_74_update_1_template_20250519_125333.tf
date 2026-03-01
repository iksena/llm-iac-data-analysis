provider "aws" {
  region = "us-west-2"
}

# Variables with default values
variable "index_name" {
  description = "Name of the Kendra index"
  type        = string
  default     = "example-kendra-index"
}

variable "data_source_name" {
  description = "Name of the Kendra data source"
  type        = string
  default     = "example-data-source"
}

# Create IAM role for Kendra
resource "aws_iam_role" "kendra_role" {
  name = "kendra-service-role"

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
resource "aws_iam_role_policy_attachment" "kendra_policy" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSKendraServiceRole"
}

# Create Kendra Index
resource "aws_kendra_index" "example" {
  name        = var.index_name
  description = "Example Kendra index"
  role_arn    = aws_iam_role.kendra_role.arn

  edition = "DEVELOPER_EDITION"  # or "ENTERPRISE_EDITION"

  tags = {
    Environment = "production"
  }
}

# Create Kendra data source with proxy configuration
resource "aws_kendra_data_source" "example" {
  index_id = aws_kendra_index.example.id
  name     = var.data_source_name
  type     = "WEBCRAWLER"
  role_arn = aws_iam_role.kendra_role.arn

  configuration {
    web_crawler_configuration {
      urls {
        seed_url_configuration {
          seed_urls = ["https://example.com"]
        }
      }
      proxy_configuration {
        host     = "proxy.example.com"
        port     = 8080
        credentials = "proxy-credentials"
      }
    }
  }

  schedule = "cron(0 0 * * ? *)"  # Run daily at midnight

  tags = {
    Environment = "production"
  }
}

# Output the index ID and data source ID
output "kendra_index_id" {
  value = aws_kendra_index.example.id
}

output "kendra_data_source_id" {
  value = aws_kendra_data_source.example.id
}