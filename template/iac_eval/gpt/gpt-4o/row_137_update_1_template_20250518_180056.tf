provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "elasticache_role" {
  name = "ElastiCacheAccessRole"

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

resource "aws_iam_role_policy" "elasticache_policy" {
  name   = "ElastiCacheAccessPolicy"
  role   = aws_iam_role.elasticache_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticache:*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_elasticache_user_group" "example" {
  user_group_id = "example-user-group"
  engine        = "redis"

  user_ids = [
    "user1",
    "user2"
  ]
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