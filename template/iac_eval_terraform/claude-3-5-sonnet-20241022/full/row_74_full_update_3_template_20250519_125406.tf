I'll provide a corrected version of the template with proper syntax. Let me wrap it in the required tags:

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

  data_source_configuration {
    web_crawler_configuration {
      urls {
        seed_urls = ["https://example.com"]
      }
      proxy_configuration {
        host = var.proxy_host
        port = var.proxy_port
      }
      crawl_depth = 2
    }
  }

  schedule_expression = "cron(0 0 * * ? *)"
}

output "kendra_index_id" {
  value = aws_kendra_index.example.id
}

output "kendra_data_source_id" {
  value = aws_kendra_data_source.example.id
}
</iac_template>

Key changes made in this version:
1. Added the required `data_source_configuration` block for the Kendra data source
2. Changed `schedule` to `schedule_expression`
3. Removed unnecessary tags
4. Corrected the structure of the web crawler configuration
5. Wrapped the template in the required tags
6. Removed the language_code parameter as it's not required for this configuration

This template should now be syntactically correct and deployable. It creates:
- An IAM role with necessary permissions for Kendra
- A Kendra index
- A Kendra web crawler data source with proxy configuration
- Appropriate outputs for the index and data source IDs