provider "aws" {
  region = "us-west-2"
}

resource "aws_elasticache_user" "example" {
  user_id   = "my-elasticache-user"
  user_name = "my-elasticache-user"
  engine    = "redis"
  no_password_required = true
  access_string = "on ~* &* +@all"
  authentication_mode {
    type = "iam"
  }
}

resource "aws_iam_role" "elasticache_access" {
  name = "ElasticacheAccessRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "elasticache.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "elasticache_policy" {
  name        = "ElasticacheAccessPolicy"
  description = "Policy to allow access to ElastiCache"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "elasticache:Connect"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.elasticache_access.name
  policy_arn = aws_iam_policy.elasticache_policy.arn
}

resource "aws_elasticache_user_group" "example_group" {
  user_group_id = "my-elasticache-user-group"
  engine        = "redis"
  user_ids      = [aws_elasticache_user.example.user_id]
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "my-redis-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis6.x"
  user_group_ids       = [aws_elasticache_user_group.example_group.user_group_id]
}