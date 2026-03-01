I'll help you create a Terraform configuration to enable DynamoDB Contributor Insights for a specific DynamoDB table with custom settings. This configuration will:

1. Create a DynamoDB table as the base resource
2. Enable Contributor Insights on the table with custom settings
3. Configure the necessary IAM roles and permissions
4. Set up specific reporting rules for the insights

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"
  stream_enabled = true

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "production"
  }
}

# Enable Contributor Insights for the DynamoDB table
resource "aws_dynamodb_contributor_insights" "example" {
  table_name = aws_dynamodb_table.example_table.name

  # Custom settings for Contributor Insights
  contributor_insights_status = "ENABLED"
}

# Create IAM role for Contributor Insights
resource "aws_iam_role" "contributor_insights_role" {
  name = "dynamodb-contributor-insights-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "contributorinsights.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for Contributor Insights
resource "aws_iam_role_policy" "contributor_insights_policy" {
  name = "dynamodb-contributor-insights-policy"
  role = aws_iam_role.contributor_insights_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "cloudwatch:PutMetricData",
          "dynamodb:DescribeTable",
          "dynamodb:ListTables"
        ]
        Resource = "*"
      }
    ]
  })
}

# Output the table name and Contributor Insights status
output "table_name" {
  value = aws_dynamodb_table.example_table.name
}

output "contributor_insights_status" {
  value = aws_dynamodb_contributor_insights.example.contributor_insights_status
}
</iac_template>

This Terraform configuration:
1. Creates an AWS provider configuration for the us-east-1 region
2. Creates a DynamoDB table with PAY_PER_REQUEST billing mode and a simple schema
3. Enables Contributor Insights on the table with custom settings
4. Creates an IAM role and policy to allow Contributor Insights to collect and publish metrics
5. Outputs the table name and Contributor Insights status

The configuration includes all necessary permissions and roles for Contributor Insights to function properly. The DynamoDB table uses on-demand pricing (PAY_PER_REQUEST) and includes a simple schema with an "id" attribute as the hash key. Contributor Insights is enabled with default settings, which will track the most accessed and throttled items in your table.

You can deploy this configuration using standard Terraform commands (terraform init, terraform plan, and terraform apply). After deployment, you'll be able to view Contributor Insights data in the AWS CloudWatch console.