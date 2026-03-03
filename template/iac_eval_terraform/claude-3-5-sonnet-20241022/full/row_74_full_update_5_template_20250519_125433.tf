I'll provide a corrected template that properly defines the URLs configuration for the Kendra data source:

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
      urls {
        seed_url_configuration {
          seed_urls = ["https://example.com"]
        }
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

This template includes the following corrections:
1. Fixed the URLs configuration block structure within the web_crawler_configuration
2. Added the required seed_url_configuration block with seed_urls
3. Maintained proper nesting of configuration blocks
4. Kept all other configurations intact including the proxy configuration

The template now properly defines a Kendra data source with web crawler configuration, including both URL and proxy settings. The web crawler will start from the specified seed URL and crawl to a depth of 2 levels, using the specified proxy configuration for access.