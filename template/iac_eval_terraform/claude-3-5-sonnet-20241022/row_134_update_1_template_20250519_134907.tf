provider "aws" {
  region = "us-west-2"
}

# Create ElastiCache User
resource "aws_elasticache_user" "redis_user" {
  user_id       = "redis-user-1"
  user_name     = "default-user"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = ["MyPassword123!"] # You should change this in production

  authentication_mode {
    type      = "password"
    passwords = ["MyPassword123!"] # You should change this in production
  }

  tags = {
    Environment = "production"
    Service     = "redis"
  }
}

# Output the user ARN
output "elasticache_user_arn" {
  value = aws_elasticache_user.redis_user.arn
}