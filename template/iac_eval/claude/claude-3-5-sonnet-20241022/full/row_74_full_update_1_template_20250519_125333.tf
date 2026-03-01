I'll help you create a Terraform configuration for an AWS Kendra data source with a proxy configuration. This configuration will:

1. Create an AWS Kendra index (required for data sources)
2. Create an IAM role for Kendra service
3. Create a Kendra data source with proxy configuration
4. Set up necessary permissions and policies

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
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
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-west-2 region
2. Variables for the index and data source names with default values
3. An IAM role with the necessary permissions for Kendra
4. A Kendra index using the DEVELOPER_EDITION
5. A Kendra data source with:
   - Web crawler configuration
   - Proxy configuration with host, port, and credentials
   - Daily schedule using a cron expression
6. Output values for the index and data source IDs

The proxy configuration is specified within the web crawler configuration, allowing the crawler to access websites through a proxy server. The configuration includes:
- Host: proxy.example.com
- Port: 8080
- Credentials for proxy authentication

To use this configuration, you would need to:
1. Replace the proxy host, port, and credentials with your actual proxy server details
2. Adjust the seed URLs to match your actual web crawling targets
3. Modify the schedule if you need a different crawling frequency
4. Choose the appropriate Kendra edition (DEVELOPER_EDITION or ENTERPRISE_EDITION)

Remember that Kendra is not available in all AWS regions, so make sure to deploy in a supported region.