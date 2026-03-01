I'll help you create a Terraform configuration that sets up an AWS ElastiCache user resource with associated IAM roles. This configuration will:

1. Create an IAM role for ElastiCache access
2. Create an ElastiCache user with authentication
3. Set up necessary IAM policies
4. Configure the AWS provider in the us-east-1 region

Here's the complete Terraform configuration:

<iac_template>
# Configure AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create IAM role for ElastiCache
resource "aws_iam_role" "elasticache_role" {
  name = "elasticache-user-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "elasticache.amazonaws.com"
        }
      }
    ]
  })
}

# Create IAM policy for ElastiCache
resource "aws_iam_role_policy" "elasticache_policy" {
  name = "elasticache-user-policy"
  role = aws_iam_role.elasticache_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticache:*"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create ElastiCache User
resource "aws_elasticache_user" "cache_user" {
  user_id       = "mycacheuser"
  user_name     = "my-cache-user"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = ["MyPassword123!"]

  authentication_mode {
    type      = "password"
    passwords = ["MyPassword123!"]
  }

  tags = {
    Environment = "production"
    Purpose     = "cache-authentication"
  }
}

# Variables with default values
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# Output the ElastiCache user ARN
output "elasticache_user_arn" {
  value = aws_elasticache_user.cache_user.arn
}
</iac_template>

This Terraform configuration creates:

1. An AWS provider configuration for the us-east-1 region
2. An IAM role that ElastiCache can assume
3. An IAM policy attached to the role with necessary permissions
4. An ElastiCache user with password authentication
5. Appropriate variables and outputs

The ElastiCache user is configured with:
- A unique user ID and name
- Password authentication
- Full access to Redis commands (can be restricted based on needs)
- Appropriate tags for resource management

The configuration includes all necessary components and can be deployed directly. The password is included in plain text for demonstration purposes - in a production environment, you should use AWS Secrets Manager or similar service to manage sensitive information.