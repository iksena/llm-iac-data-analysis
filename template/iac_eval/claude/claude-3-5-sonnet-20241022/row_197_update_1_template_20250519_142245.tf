provider "aws" {
  region = "us-east-1"
}

# Create ElastiCache Users
resource "aws_elasticache_user" "user1" {
  user_id       = "elasticache-user1"
  user_name     = "firstuser"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = ["UserPassword123!"]
}

resource "aws_elasticache_user" "user2" {
  user_id       = "elasticache-user2"
  user_name     = "seconduser"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = ["UserPassword456!"]
}

resource "aws_elasticache_user" "user3" {
  user_id       = "elasticache-user3"
  user_name     = "thirduser"
  access_string = "on ~* +@all"
  engine        = "REDIS"
  passwords     = ["UserPassword789!"]
}

# Create ElastiCache User Group
resource "aws_elasticache_user_group" "example" {
  engine        = "REDIS"
  user_group_id = "elasticache-usergroup1"

  user_ids = [
    aws_elasticache_user.user1.user_id,
    aws_elasticache_user.user2.user_id,
    aws_elasticache_user.user3.user_id
  ]
}