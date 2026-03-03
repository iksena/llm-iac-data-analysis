provider "aws" {
  region = "us-west-2"
}

# Data source to fetch the existing ElastiCache user
data "aws_elasticache_user" "existing_user" {
  user_id = "my-existing-user-id" # Replace with your actual ElastiCache user ID
}

# Data source to fetch the existing ElastiCache user group
data "aws_elasticache_user_group" "existing_user_group" {
  user_group_id = "my-existing-user-group-id" # Replace with your actual ElastiCache user group ID
}

# Resource to associate the ElastiCache user with the user group
resource "aws_elasticache_user_group_association" "user_group_association" {
  user_group_id = data.aws_elasticache_user_group.existing_user_group.user_group_id
  user_id       = data.aws_elasticache_user.existing_user.user_id
}