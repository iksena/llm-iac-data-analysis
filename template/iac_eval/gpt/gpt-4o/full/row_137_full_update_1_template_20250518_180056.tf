To fulfill the business need, we will create a Terraform configuration that sets up an Amazon ElastiCache User Group. This configuration will include the necessary AWS provider setup, an IAM role for ElastiCache access, and the ElastiCache User Group resource itself. The ElastiCache User Group will be configured to manage access to ElastiCache clusters, allowing you to define which users can access the clusters and what permissions they have.

Below is the Terraform HCL configuration for creating an ElastiCache User Group:

<iac_template>
```hcl
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
```
</iac_template>

This configuration sets up an ElastiCache User Group with two users, `user1` and `user2`, each having access to Redis clusters. The IAM role and policy are configured to allow ElastiCache service to assume the role and perform necessary actions. The users are defined with specific access strings and passwords.