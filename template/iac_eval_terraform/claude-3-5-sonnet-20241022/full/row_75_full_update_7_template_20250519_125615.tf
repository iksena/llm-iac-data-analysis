I'll provide a corrected template that follows the proper AWS Kendra data source configuration syntax:

<iac_template>
provider "aws" {
  region = "us-east-1"
}

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
resource "aws_iam_role_policy_attachment" "kendra_policy_attachment" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSKendraServiceRole"
}

# Create Kendra Index
resource "aws_kendra_index" "example" {
  name        = var.index_name
  description = "Example Kendra Index"
  role_arn    = aws_iam_role.kendra_role.arn
  edition     = "DEVELOPER_EDITION"

  depends_on = [aws_iam_role_policy_attachment.kendra_policy_attachment]
}

# Create Kendra Data Source
resource "aws_kendra_data_source" "example" {
  depends_on = [aws_kendra_index.example]
  
  index_id = aws_kendra_index.example.id
  name     = var.data_source_name
  type     = "WEBCRAWLER"
  role_arn = aws_iam_role.kendra_role.arn

  configuration {
    web_crawler_configuration {
      urls {
        seed_url_configuration {
          seed_urls = ["https://example.com"]
          web_crawler_mode = "HOST_ONLY"
        }
        
        inclusion_patterns = [
          "https://example.com/docs/*",
          "https://example.com/blog/*"
        ]

        exclusion_patterns = [
          "https://example.com/docs/internal/*",
          "https://example.com/blog/draft/*"
        ]
      }
      
      crawl_depth = 2
      max_links_per_page = 100
    }
  }

  schedule = "cron(0 0 * * ? *)"
  language_code = "en"
  description   = "Web crawler data source with URL patterns"
}
</iac_template>

The main changes in this version:
1. Changed `url_inclusion_patterns` to `inclusion_patterns`
2. Changed `url_exclusion_patterns` to `exclusion_patterns`
3. Added `web_crawler_mode` to the `seed_url_configuration`
4. Maintained proper nesting of configuration blocks

This template should now properly define a Kendra data source with URL inclusion and exclusion patterns for web crawling.