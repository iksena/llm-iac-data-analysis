I'll provide a corrected version of the template that follows the correct AWS Kendra data source configuration syntax.

<iac_template>
provider "aws" {
  region = "us-west-2"
}

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

variable "proxy_host" {
  description = "Proxy host address"
  type        = string
  default     = "proxy.example.com"
}

variable "proxy_port" {
  description = "Proxy port number"
  type        = number
  default     = 8080
}

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

resource "aws_iam_role_policy" "kendra_policy" {
  name = "kendra-service-policy"
  role = aws_iam_role.kendra_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "kendra:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_kendra_index" "example" {
  name        = var.index_name
  description = "Example Kendra index"
  role_arn    = aws_iam_role.kendra_role.arn
  edition     = "DEVELOPER_EDITION"
}

resource "aws_kendra_data_source" "example" {
  depends_on = [aws_iam_role_policy.kendra_policy]
  index_id   = aws_kendra_index.example.id
  name       = var.data_source_name
  type       = "WEBCRAWLER"
  role_arn   = aws_iam_role.kendra_role.arn

  configuration {
    web_crawler_configuration {
      crawl_depth = 2
      url_configuration {
        urls = ["https://example.com"]
      }
      proxy_configuration {
        host = var.proxy_host
        port = var.proxy_port
      }
    }
  }

  schedule = "cron(0 0 * * ? *)"
}

output "kendra_index_id" {
  value = aws_kendra_index.example.id
}

output "kendra_data_source_id" {
  value = aws_kendra_data_source.example.id
}
</iac_template>

The main changes made to fix the syntax errors:
1. Removed `data_source_configuration` block and replaced it with `configuration`
2. Updated the web crawler configuration structure to use `url_configuration` instead of `urls`
3. Adjusted the nesting of configuration blocks to match the AWS provider's expected structure
4. Changed `schedule_expression` to `schedule`

This template should now properly create a Kendra index and data source with a proxy configuration while following the correct syntax for the AWS provider.