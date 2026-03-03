provider "aws" {
  region = "us-east-1"
}

# Create DynamoDB table
resource "aws_dynamodb_table" "example_table" {
  name           = "example-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Environment = "production"
  }
}

# Enable CloudWatch Contributor Insights rule for DynamoDB
resource "aws_cloudwatch_contributor_insights_rule" "dynamodb_rule" {
  name    = "DynamoDBInsightsRule"
  rule_id = "DynamoDBContributorInsights"

  contribution_data_source {
    data_source_name = "AWS::DynamoDB::Table"
    resource_arn     = aws_dynamodb_table.example_table.arn
  }

  tags = {
    Environment = "production"
  }
}

# Output the table name
output "table_name" {
  description = "Name of the DynamoDB table"
  value       = aws_dynamodb_table.example_table.name
}

output "contributor_insights_rule" {
  description = "Name of the Contributor Insights rule"
  value       = aws_cloudwatch_contributor_insights_rule.dynamodb_rule.name
}