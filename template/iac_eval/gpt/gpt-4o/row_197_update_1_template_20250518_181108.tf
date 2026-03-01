provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "elasticache_user_role" {
  name = "ElastiCacheUserRole"

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

resource "aws_elasticache_user" "user1" {
  user_id   = "user1"
  user_name = "user1"
  engine    = "redis"
  passwords = ["password1"]
  access_string = "on ~* +@all"
}

resource "aws_elasticache_user" "user2" {
  user_id   = "user2"
  user_name = "user2"
  engine    = "redis"
  passwords = ["password2"]
  access_string = "on ~* +@all"
}

resource "aws_elasticache_user" "user3" {
  user_id   = "user3"
  user_name = "user3"
  engine    = "redis"
  passwords = ["password3"]
  access_string = "on ~* +@all"
}

resource "aws_elasticache_user_group" "example" {
  user_group_id = "example-group"
  engine        = "redis"
  user_ids      = [
    aws_elasticache_user.user1.user_id,
    aws_elasticache_user.user2.user_id,
    aws_elasticache_user.user3.user_id
  ]
}