provider "aws" {
  region = "us-west-2"
}

resource "aws_iam_role" "elasticache_access_role" {
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

resource "aws_iam_policy" "elasticache_access_policy" {
  name        = "ElastiCacheAccessPolicy"
  description = "Policy to allow access to ElastiCache resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "elasticache:Describe*",
          "elasticache:List*",
          "elasticache:Get*"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "elasticache_access_policy_attachment" {
  role       = aws_iam_role.elasticache_access_role.name
  policy_arn = aws_iam_policy.elasticache_access_policy.arn
}

resource "aws_elasticache_cluster" "example" {
  cluster_id           = "example-cluster"
  engine               = "redis"
  node_type            = "cache.t2.micro"
  num_cache_nodes      = 1
  parameter_group_name = "default.redis3.2"
}

output "elasticache_cluster_endpoint" {
  value = aws_elasticache_cluster.example.cache_nodes[0].address
}