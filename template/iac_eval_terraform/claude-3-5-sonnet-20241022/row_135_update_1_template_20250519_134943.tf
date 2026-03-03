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