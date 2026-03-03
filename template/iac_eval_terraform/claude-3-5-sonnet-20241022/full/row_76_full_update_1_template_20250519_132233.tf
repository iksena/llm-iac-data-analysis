I'll help you create a Terraform configuration to deploy an Amazon Kendra index with default document metadata configuration updates. This configuration will:

1. Create an IAM role and policy for Kendra service
2. Create a basic Kendra index with default settings
3. Include necessary document metadata configuration updates

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for Kendra
resource "aws_iam_role" "kendra_role" {
  name = "kendra_service_role"

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
  name = "kendra_service_policy"
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
  name        = "example-kendra-index"
  description = "Example Kendra Index with default configuration"
  role_arn    = aws_iam_role.kendra_role.arn

  document_metadata_configuration_updates {
    name            = "_created_at"
    type            = "DATE_VALUE"
    relevance {
      freshness = true
    }
  }

  document_metadata_configuration_updates {
    name            = "_last_updated_at"
    type            = "DATE_VALUE"
    relevance {
      freshness = true
    }
  }

  document_metadata_configuration_updates {
    name            = "_source_uri"
    type            = "STRING_VALUE"
    relevance {
      importance = 1
    }
  }

  tags = {
    Environment = "production"
  }
}

# Output the Index ID
output "kendra_index_id" {
  value = aws_kendra_index.example.id
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role with the necessary permissions for Kendra to operate
3. A Kendra index with default document metadata configuration updates for:
   - _created_at (DATE_VALUE)
   - _last_updated_at (DATE_VALUE)
   - _source_uri (STRING_VALUE)
4. Appropriate tags for resource management
5. An output to display the created Kendra index ID

The configuration includes the minimum required permissions for the Kendra service to function properly, including CloudWatch metrics and logging capabilities. The document metadata configuration updates are set with common default fields that are typically used in Kendra indexes.

To deploy this configuration, you would need to:
1. Have AWS credentials configured
2. Have sufficient permissions in your AWS account
3. Run `terraform init` followed by `terraform apply`

Note that Kendra indexes can incur significant costs, so make sure to review the AWS pricing before deploying this configuration.