I'll help you create a Terraform configuration for an AWS Kendra data source with URL exclusion and inclusion patterns. This configuration will:

1. Create an AWS Kendra index
2. Create an IAM role for Kendra with necessary permissions
3. Create a Kendra web crawler data source with URL inclusion and exclusion patterns
4. Set up the crawler configuration with specific patterns to include and exclude URLs

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. Variables for the index and data source names with default values
3. An IAM role with necessary permissions for Kendra to operate
4. A Kendra index using the DEVELOPER_EDITION
5. A Kendra web crawler data source with:
   - A seed URL (example.com)
   - URL inclusion patterns for docs and blog sections
   - URL exclusion patterns for internal docs and draft blog posts
   - Crawl depth set to 2 levels
   - Host-only crawling mode

The URL inclusion and exclusion patterns help control which URLs the crawler will index:
- Inclusion patterns: Only URLs matching these patterns will be crawled
- Exclusion patterns: URLs matching these patterns will be skipped, even if they match inclusion patterns

To use this configuration, you would need to:
1. Have appropriate AWS credentials configured
2. Modify the seed URLs, inclusion patterns, and exclusion patterns according to your needs
3. Adjust the index edition if needed (DEVELOPER_EDITION or ENTERPRISE_EDITION)
4. Consider the costs associated with running a Kendra index and data source

Remember that Kendra is a relatively expensive service, so make sure to review the pricing before deployment.