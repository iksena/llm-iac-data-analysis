provider "aws" {
  region = "us-west-2"
}

# Create ElastiCache User Group
resource "aws_elasticache_user_group" "example" {
  engine        = "REDIS"
  user_group_id = "my-example-user-group"
  user_ids      = []  # Empty list as default
}

# Output the User Group ARN
output "user_group_arn" {
  value = aws_elasticache_user_group.example.arn
}