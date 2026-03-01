provider "aws" {
  region = "us-west-2"
}

resource "aws_elasticache_user" "example" {
  user_id   = "my-redis-user"
  user_name = "myRedisUser"
  engine    = "redis"
  passwords = [var.redis_user_password]
  access_string = "on ~* +@all"

  tags = {
    Name = "MyRedisUser"
  }
}

variable "redis_user_password" {
  description = "The password for the ElastiCache Redis user"
  type        = string
  sensitive   = true
  default     = "defaultPassword123!" # Replace with a secure password
}