provider "aws" {
  region = "us-west-2"
}

# Variable for the password
variable "elasticache_user_password" {
  description = "Password for ElastiCache user"
  type        = string
  default     = "MyP@ssw0rd123!" # Change this in production
  sensitive   = true
}

# Variable for the username
variable "elasticache_username" {
  description = "Username for ElastiCache user"
  type        = string
  default     = "cache-admin"
}

# Create ElastiCache User
resource "aws_elasticache_user" "cache_user" {
  user_id       = var.elasticache_username
  user_name     = var.elasticache_username
  access_string = "on ~* +@all"  # Grants all permissions
  engine        = "REDIS"
  passwords     = [var.elasticache_user_password]

  authentication_mode {
    type      = "password"
    passwords = [var.elasticache_user_password]
  }
}

# Output the user ID
output "elasticache_user_id" {
  value = aws_elasticache_user.cache_user.user_id
}