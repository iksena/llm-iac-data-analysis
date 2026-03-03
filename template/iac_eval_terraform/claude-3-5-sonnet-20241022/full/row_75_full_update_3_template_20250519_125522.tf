I'll provide a corrected version of the Terraform configuration for creating a Kendra data source with URL exclusion and inclusion patterns.

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

  data_source_configuration {
    web_crawler_configuration {
      crawl_depth = 2
      max_links_per_page = 100
      
      urls {
        seed_urls = ["https://example.com"]
        
        url_inclusion_patterns = [
          "https://example.com/docs/*",
          "https://example.com/blog/*"
        ]

        url_exclusion_patterns = [
          "https://example.com/docs/internal/*",
          "https://example.com/blog/draft/*"
        ]
      }
    }
  }

  schedule = "cron(0 0 * * ? *)"

  language_code = "en"
  description   = "Web crawler data source with URL patterns"
}
</iac_template>

Key changes made in this version:
1. Changed `configuration` to `data_source_configuration` in the Kendra data source
2. Corrected the structure of the web crawler configuration
3. Added proper tags around the template
4. Maintained consistent indentation
5. Kept the necessary IAM roles and policies
6. Included all required fields for the web crawler configuration

This template will create:
- An IAM role for Kendra with appropriate permissions
- A Kendra index
- A Kendra web crawler data source with specified URL inclusion and exclusion patterns
- The web crawler will crawl to a depth of 2 levels and process up to 100 links per page
- The crawler will run daily at midnight (UTC) according to the cron schedule
- The crawler will include URLs matching the inclusion patterns and exclude those matching the exclusion patterns