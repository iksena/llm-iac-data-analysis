provider "aws" {
  region = "us-east-1"
}

# Create ElastiCache User
resource "aws_elasticache_user" "cache_user" {
  user_id       = "mycacheuser"
  user_name     = "my-cache-user"
  access_string = "on ~* +@all"
  engine        = "REDIS"

  authentication_mode {
    type      = "password"
    passwords = ["MyP@ssw0rd123"]
  }

  tags = {
    Environment = var.environment
    Purpose     = "cache-authentication"
  }
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
resource "aws_iam_policy" "elasticache_policy" {
  name = "elasticache-user-policy"
  description = "Policy for ElastiCache user access"

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

# Attach policy to role
resource "aws_iam_role_policy_attachment" "elasticache_policy_attachment" {
  policy_arn = aws_iam_policy.elasticache_policy.arn
  role       = aws_iam_role.elasticache_role.name
}

# Variables
variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

# Outputs
output "elasticache_user_arn" {
  value = aws_elasticache_user.cache_user.arn
}

output "elasticache_role_arn" {
  value = aws_iam_role.elasticache_role.arn
}