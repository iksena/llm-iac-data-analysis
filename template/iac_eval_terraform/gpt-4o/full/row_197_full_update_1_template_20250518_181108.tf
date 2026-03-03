To fulfill the business need, we will create a Terraform configuration that sets up an AWS ElastiCache User Group with three users. This configuration will include the necessary IAM roles and policies to manage the ElastiCache resources. We will use the AWS provider and specify a region for deployment. The ElastiCache User Group will be configured with three users, each having a unique username. 

Here is the Terraform HCL configuration:

<iac_template>
```hcl
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
```
</iac_template>

This configuration sets up an ElastiCache User Group with three users, each having a unique user ID and password. The users are granted full access to all commands and keys in the Redis engine. The configuration also includes an IAM role that allows ElastiCache to assume the necessary permissions.