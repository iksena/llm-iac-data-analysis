Below is the complete Terraform configuration. In this example we create an AWS Kendra index (which is required by the data source), an IAM role for the index, and an IAM role for the Kendra data source. The Kendra data source resource is configured for an S3 data source and includes a proxy configuration (with host and port information). You can adjust the variable defaults (for proxy host, proxy port, and S3 bucket name) as needed.

<iac_template>
provider "aws" {
  region = "us-west-2"
}

# -------------------------------
# IAM Role for Kendra Index
# -------------------------------
resource "aws_iam_role" "kendra_index" {
  name = "kendra-index-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "kendra.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach a managed policy (example: full access for Kendra operations)
resource "aws_iam_role_policy_attachment" "kendra_index_attach" {
  role       = aws_iam_role.kendra_index.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonKendraFullAccess"
}

# -------------------------------
# AWS Kendra Index Resource
# -------------------------------
resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  role_arn    = aws_iam_role.kendra_index.arn
  edition     = "DEVELOPER_EDITION"
  description = "Example Kendra index created for a data source with proxy config"
}

# -------------------------------
# IAM Role for Kendra Data Source
# -------------------------------
resource "aws_iam_role" "kendra_datasource" {
  name = "kendra-datasource-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "kendra.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

# Attach S3 read-only access to the Kendra Data Source role (assuming the data is in S3)
resource "aws_iam_role_policy_attachment" "kendra_datasource_attach" {
  role       = aws_iam_role.kendra_datasource.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

# -------------------------------
# AWS Kendra Data Source with Proxy Configuration
# -------------------------------
resource "aws_kendra_data_source" "example" {
  name        = "example-s3-data-source"
  index_id    = aws_kendra_index.example.id
  type        = "S3"
  role_arn    = aws_iam_role.kendra_datasource.arn
  schedule    = "rate(24 hours)"
  description = "Example S3 DataSource for Kendra including a proxy configuration"

  s3_configuration {
    bucket_name        = var.s3_bucket_name
    inclusion_prefixes = [""]
  }

  proxy_configuration {
    host = var.proxy_host
    port = var.proxy_port
  }
}

# -------------------------------
# Variables with Default Values
# -------------------------------
variable "s3_bucket_name" {
  description = "S3 bucket name for the Kendra data source"
  type        = string
  default     = "example-bucket"
}

variable "proxy_host" {
  description = "Proxy host for Kendra data source connections"
  type        = string
  default     = "proxy.example.com"
}

variable "proxy_port" {
  description = "Proxy port for Kendra data source connections"
  type        = number
  default     = 8080
}
</iac_template>

To deploy this configuration, save it to a file (for example, main.tf), ensure your AWS credentials are configured, and then run:

  terraform init
  terraform plan
  terraform apply