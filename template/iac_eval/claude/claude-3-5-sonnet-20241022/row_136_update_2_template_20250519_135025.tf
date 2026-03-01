provider "aws" {
  region = "us-west-2"
}

variable "elasticache_user_password" {
  description = "Password for ElastiCache user"
  type        = string
  default     = "MyP@ssw0rd123!"
  sensitive   = true
}

variable "elasticache_username" {
  description = "Username for ElastiCache user"
  type        = string
  default     = "cacheadmin"
}

resource "aws_elasticache_user" "cache_user" {
  user_id       = var.elasticache_username
  user_name     = var.elasticache_username
  access_string = "on ~* +@all"
  engine        = "REDIS"

  authentication_mode {
    type      = "password"
    passwords = [var.elasticache_user_password]
  }
}

output "elasticache_user_id" {
  value = aws_elasticache_user.cache_user.user_id
}