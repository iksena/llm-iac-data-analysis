provider "aws" {
  region = "us-west-2"
}

# Variables
variable "user_group_id" {
  description = "The ID of the user group"
  type        = string
  default     = "my-user-group"
}

variable "engine" {
  description = "The engine used for the user group"
  type        = string
  default     = "REDIS"
}

# Create ElastiCache User
resource "aws_elasticache_user" "default" {
  user_id       = "default-user"
  user_name     = "defaultuser"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = ["Password123!"]
}

# Create ElastiCache User Group
resource "aws_elasticache_user_group" "example" {
  engine        = var.engine
  user_group_id = var.user_group_id
  user_ids      = [aws_elasticache_user.default.user_id]
}

# Output
output "user_group_arn" {
  description = "The ARN of the created user group"
  value       = aws_elasticache_user_group.example.arn
}