Below is the description and complete Terraform HCL template.

Description:
This Terraform configuration provisions an AWS Kendra data source resource for crawling websites. The data source uses the WEBSITE type and is configured with URL exclusion and inclusion patterns. A new IAM role is created so that AWS Kendra can assume it. The configuration includes a website configuration with a seed URL, a specified crawl depth, and lists of URL patterns to exclude and include during the crawl. All required resources—including an IAM role, an IAM role policy, a Kendra data source, and provider setup—are declared so that the configuration is fully deployable.

<iac_template>
provider "aws" {
  region = "us-east-1"
}

variable "kendra_index_id" {
  description = "The ID of the Kendra index to attach the data source to."
  default     = "your-kendra-index-id"
}

resource "aws_iam_role" "kendra_role" {
  name = "kendra_data_source_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "kendra_policy" {
  name = "kendra_policy"
  role = aws_iam_role.kendra_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetObject"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kendra_data_source" "my_data_source" {
  name     = "my_website_data_source"
  index_id = var.kendra_index_id
  type     = "WEBSITE"
  role_arn = aws_iam_role.kendra_role.arn

  configuration {
    website_configuration {
      crawl_depth = 2

      seed_url_configuration {
        seed_urls = ["https://example.com"]
      }

      url_exclusion_patterns = [
        "https://example.com/exclude/.*"
      ]

      url_inclusion_patterns = [
        "https://example.com/included/.*"
      ]
    }
  }
}
</iac_template>