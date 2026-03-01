I'll help you create a Terraform configuration to deploy an Amazon Kendra index with user group resolution configuration. This configuration will:

1. Create an IAM role for Kendra service with necessary permissions
2. Create a basic Kendra index with user group resolution enabled
3. Configure the required policies and settings

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
resource "aws_iam_role_policy_attachment" "kendra_policy" {
  role       = aws_iam_role.kendra_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSKendraServiceRole"
}

# Create Kendra Index
resource "aws_kendra_index" "example" {
  name        = "example-kendra-index"
  description = "Example Kendra Index with user group resolution"
  role_arn    = aws_iam_role.kendra_role.arn

  # Configure user group resolution
  user_group_resolution_configuration {
    user_group_resolution_mode = "AWS_SSO"
  }

  # Required server side encryption configuration
  server_side_encryption_configuration {
    kms_key_id = "aws/kendra"
  }

  # Required edition
  edition = "DEVELOPER_EDITION"

  tags = {
    Environment = "production"
    Purpose     = "search"
  }
}

# Output the Index ID
output "kendra_index_id" {
  value = aws_kendra_index.example.id
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role that Kendra can assume to perform its operations
3. Attaches the necessary AWS managed policy to the IAM role
4. Creates a Kendra index with:
   - User group resolution configured for AWS SSO
   - Server-side encryption using AWS managed KMS key
   - Developer Edition of Kendra
   - Basic tagging for resource management

The configuration includes all necessary components and permissions for the Kendra index to function properly. The user group resolution is set to use AWS SSO, which allows for integration with your organization's identity provider.

Note that this is a basic configuration and you might need to adjust:
- The region
- The index name
- The edition (DEVELOPER_EDITION or ENTERPRISE_EDITION)
- The tags
- The KMS key configuration

Also, be aware that Amazon Kendra is a relatively expensive service, so make sure you understand the pricing implications before deploying this infrastructure.